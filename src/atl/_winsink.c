


/*
Reference material:

http://codeguru.earthweb.com/mfc/comments/55024.shtml

Several examples here:
http://www.john.findlay1.btinternet.co.uk/OLE/ole.htm

ADO example here:
http://www.john.findlay1.btinternet.co.uk/DataBase/database.htm

HOWTO: Use OLE Automation from a C Application Rather Than C++:
http://support.microsoft.com/default.aspx?scid=http://support.microsoftcom:80/support/kb/articles/q181/4/73.asp&NoWebContent=1

The Microsoft B2C.EXE utility, which converts Microsoft Visual Basic Automation code into Microsoft Visual C++ code.
http://support.microsoft.com/default.aspx?scid=kb;EN-US;216388
*/

//#include "hbvmopt.h" //oskar
#include <windows.h>
#include <oaidl.h>
#include "hbapi.h"
#include "item.api"
#include "hbapiitm.h"
#include "hbapierr.h"
#include "hbvm.h"
#include "hbstack.h"
#include <shlobj.h>
#include <objbase.h>
#include <ocidl.h>
#include <olectl.h>
#include <ole2.h>
#include <oleauto.h>

HB_EXPORT void hb_oleItemToVariant( VARIANT *pVariant, PHB_ITEM pItem );
HRESULT hb_oleVariantToItem( PHB_ITEM pItem, VARIANT *pVariant );


//------------------------------------------------------------------------------

void HB_EXPORT hb_itemPushList( ULONG ulRefMask, ULONG ulPCount, PHB_ITEM** pItems )
{
   HB_ITEM itmRef;
   ULONG ulParam;

   if( ulPCount )
   {
      // initialize the reference item
      itmRef.type = HB_IT_BYREF;
      itmRef.item.asRefer.offset = -1;
      itmRef.item.asRefer.BasePtr.itemsbasePtr = pItems;

      for( ulParam = 0; ulParam < ulPCount; ulParam++ )
      {
         if( ulRefMask & ( 1L << ulParam ) )
         {
            // when item is passed by reference then we have to put
            // the reference on the stack instead of the item itself
            itmRef.item.asRefer.value = ulParam+1;
            hb_vmPush( &itmRef );
         }
         else
         {
            hb_vmPush( (*pItems)[ulParam] );
         }
      }
   }
}


//------------------------------------------------------------------------------

void HB_EXPORT hb_itemPushRef( PHB_ITEM** ppItem )
{
   HB_ITEM itmRef;
   ULONG ulParam;

   if( ppItem )
   {
      // initialize the reference item
      itmRef.type = HB_IT_BYREF;
      itmRef.item.asRefer.offset = -1;
      itmRef.item.asRefer.BasePtr.itemsbasePtr = ppItem;
      itmRef.item.asRefer.value = 1;
      hb_vmPush( &itmRef );

   }
}


//------------------------------------------------------------------------------

//this is a macro which defines our IEventHandler struct as so:
//
// typedef struct {
//    IEventHandlerVtbl  *lpVtbl;
// } IEventHandler;


#undef  INTERFACE
#define INTERFACE IEventHandler

DECLARE_INTERFACE_ (INTERFACE, IDispatch)
{
   // IUnknown functions
   STDMETHOD  (QueryInterface) (THIS_ REFIID, void **) PURE;
   STDMETHOD_ (ULONG, AddRef)  (THIS) PURE;
   STDMETHOD_ (ULONG, Release) (THIS) PURE;
   // IDispatch functions
   STDMETHOD_ (ULONG, GetTypeInfoCount) (THIS_ UINT *) PURE;
   STDMETHOD_ (ULONG, GetTypeInfo) (THIS_ UINT, LCID, ITypeInfo **) PURE;
   STDMETHOD_ (ULONG, GetIDsOfNames) (THIS_ REFIID, LPOLESTR *, UINT, LCID, DISPID *) PURE;
   STDMETHOD_ (ULONG, Invoke) (THIS_ DISPID, REFIID, LCID, WORD, DISPPARAMS *, VARIANT *, EXCEPINFO *, UINT *) PURE;
};


// In other words, it defines our IEventHandler to have nothing
// but a pointer to its VTable. And of course, every COM object must
// start with a pointer to its VTable.
//
// But we actually want to add some more members to our IEventHandler.
// We just don't want any app to be able to know about, and directly
// access, those members. So here we'll define a MyRealIEventHandler that
// contains those extra members. The app doesn't know that we're
// really allocating and giving it a MyRealIEventHAndler object. We'll
// lie and tell it we're giving a plain old IEventHandler. That's ok
// because a MyRealIEventHandler starts with the same VTable pointer.
//
// We add a DWORD reference count so that this IEventHandler
// can be allocated (which we do in our IClassFactory object's
// CreateInstance()) and later freed. And, we have an extra
// BSTR (pointer) string, which is used by some of the functions we'll
// add to IEventHandler


typedef struct {
   DISPID   dispid;
   PHB_ITEM pSelf;
   PHB_DYNS pSymbol;
} EventMap;


typedef struct {
   IEventHandler*          lpVtbl;
   DWORD                   count;
   IConnectionPoint*       pIConnectionPoint;  // Ref counted of course.
   DWORD                   dwEventCookie;
   char*                   parent_on_invoke;
   IID                     device_event_interface_iid;
   PHB_ITEM                pSelf;        // object to handle the events
   EventMap*               pEventMap;    // event map
   int                     iEventMapLen; // length of the eventMap
} MyRealIEventHandler;


//------------------------------------------------------------------------------
// Here are IEventHandler's functions.
//------------------------------------------------------------------------------

// Every COM object's interface must have the 3 functions QueryInterface(),
// AddRef(), and Release().

// IEventHandler's QueryInterface()
static HRESULT STDMETHODCALLTYPE QueryInterface(IEventHandler *this, REFIID vTableGuid, void **ppv)
{
   // Check if the GUID matches IEvenetHandler VTable's GUID. We gave the C variable name
   // IID_IEventHandler to our VTable GUID. We can use an OLE function called
   // IsEqualIID to do the comparison for us. Also, if the caller passed a
   // IUnknown GUID, then we'll likewise return the IEventHandler, since it can
   // masquerade as an IUnknown object too. Finally, if the called passed a
   // IDispatch GUID, then we'll return the IExample3, since it can masquerade
   // as an IDispatch too

   if (IsEqualIID(vTableGuid, &IID_IUnknown) )
   {
      *ppv = (IUnknown*) this;
      // Increment the count of callers who have an outstanding pointer to this object
      this->lpVtbl->AddRef(this);
      return S_OK;
   }

   if (IsEqualIID(vTableGuid, &IID_IDispatch))
   {
      *ppv = (IDispatch*) this;
      this->lpVtbl->AddRef(this);
      return S_OK;
   }


   if ( IsEqualIID(vTableGuid, &(((MyRealIEventHandler*) this)->device_event_interface_iid )))
   {
      *ppv = (IDispatch*) this;
      this->lpVtbl->AddRef(this);
      return S_OK;
   }


   // We don't recognize the GUID passed to us. Let the caller know this,
   // by clearing his handle, and returning E_NOINTERFACE.
   *ppv = 0;
   return(E_NOINTERFACE);

}


//------------------------------------------------------------------------------

// IEventHandler's AddRef()

static ULONG STDMETHODCALLTYPE AddRef(IEventHandler *this)
{
   // Increment IEventHandler's reference count, and return the updated value.
   // NOTE: We have to typecast to gain access to any data members. These
   // members are not defined  (so that an app can't directly access them).
   // Rather they are defined only above in our MyRealIEventHandler
   // struct. So typecast to that in order to access those data members

   return(++((MyRealIEventHandler *) this)->count);

}


//------------------------------------------------------------------------------

// IEventHandler's Release()

static ULONG STDMETHODCALLTYPE Release(IEventHandler *this)
{
   if (--((MyRealIEventHandler *) this)->count == 0)
   {

      if( ( (MyRealIEventHandler *) this)->pSelf )
         hb_itemRelease( ( (MyRealIEventHandler *) this)->pSelf );

      if( ( (MyRealIEventHandler *) this)->pEventMap )
         hb_xfree( ( (MyRealIEventHandler *) this)->pEventMap );

      GlobalFree(this);
      return(0);
   }
   return(((MyRealIEventHandler *) this)->count);
}


//------------------------------------------------------------------------------

// IEventHandler's GetTypeInfoCount()

static ULONG STDMETHODCALLTYPE GetTypeInfoCount(IEventHandler *this, UINT *pCount)
{
   HB_SYMBOL_UNUSED(this);
   HB_SYMBOL_UNUSED(pCount);

   return E_NOTIMPL;
}


//------------------------------------------------------------------------------

// IEventHandler's GetTypeInfo()

static ULONG STDMETHODCALLTYPE GetTypeInfo(IEventHandler *this, UINT itinfo, LCID lcid, ITypeInfo **pTypeInfo)
{
   HB_SYMBOL_UNUSED(this);
   HB_SYMBOL_UNUSED(itinfo);
   HB_SYMBOL_UNUSED(lcid);
   HB_SYMBOL_UNUSED(pTypeInfo);

   return E_NOTIMPL;
}


//------------------------------------------------------------------------------

// IEventHandler's GetIDsOfNames()

static ULONG STDMETHODCALLTYPE GetIDsOfNames(IEventHandler *this, REFIID riid, LPOLESTR *rgszNames, UINT cNames, LCID lcid, DISPID *rgdispid)
{

   HB_SYMBOL_UNUSED(this);
   HB_SYMBOL_UNUSED(riid);
   HB_SYMBOL_UNUSED(rgszNames);
   HB_SYMBOL_UNUSED(cNames);
   HB_SYMBOL_UNUSED(lcid);
   HB_SYMBOL_UNUSED(rgdispid);

   return E_NOTIMPL;
}

//------------------------------------------------------------------------------

// IEventHandler's Invoke()
// this is where the action happens
// this function receives events (by their ID number) and distributes the processing
// or them or ignores them

static ULONG STDMETHODCALLTYPE Invoke(IEventHandler *this, DISPID dispid, REFIID riid,
                                      LCID lcid, WORD wFlags, DISPPARAMS *params,
                                      VARIANT *result, EXCEPINFO *pexcepinfo, UINT *puArgErr)
{

   char cBuff[128];  // test
   PHB_ITEM pItem;
   int iArg;
   int i;
   PHB_DYNS pSymbol;
   int iEvPos;
   PHB_ITEM pItemArray[32]; // max 32 parameters?
   PHB_ITEM *pItems;

   ULONG ulRefMask = 0;

   // We implement only a "default" interface
   if (!IsEqualIID(riid, &IID_NULL))
      return(DISP_E_UNKNOWNINTERFACE);

   HB_SYMBOL_UNUSED(lcid);
   HB_SYMBOL_UNUSED(wFlags);
   HB_SYMBOL_UNUSED(result);
   HB_SYMBOL_UNUSED(pexcepinfo);
   HB_SYMBOL_UNUSED(puArgErr);

   // test
   wsprintf( cBuff, "Event: %i", dispid ) ;

   OutputDebugString(cBuff);

   // delegate work to somewhere else in PRG
   //***************************************

   if( ((MyRealIEventHandler*) this)->pEventMap )
   {
      for( iEvPos = 0; iEvPos < ((MyRealIEventHandler*) this)->iEventMapLen; iEvPos++ )
      {
         int nEvent = ((MyRealIEventHandler*) this)->pEventMap[iEvPos].dispid; // oskar 20061116
         if( nEvent == 0 || nEvent == dispid  )                                // oskar 20061116
         {
            // save state
            hb_vmPushState();
            hb_vmPushSymbol( hb_dynsymSymbol( ((MyRealIEventHandler*) this)->pEventMap[iEvPos].pSymbol ) );
            if( ((MyRealIEventHandler*) this)->pEventMap[iEvPos].pSelf )
               hb_vmPush( ((MyRealIEventHandler*) this)->pEventMap[iEvPos].pSelf );
            else
               hb_vmPushNil();

            if( nEvent == 0 )hb_vmPushInteger( dispid );                       // oskar 20061116

            // push params (back to front!)
            iArg = params->cArgs;
            for( i = 1; i<= iArg; i++ )
            {
               pItem = hb_itemNew(NULL);
               hb_oleVariantToItem( pItem, &(params->rgvarg[iArg-i]) ); // VARIANT *pVariant )

               pItemArray[i-1] = pItem;
               // set bit i
               ulRefMask |= ( 1L << (i-1) );
            }

            if( iArg )
            {
               pItems = pItemArray;
               hb_itemPushList( ulRefMask, iArg, &pItems );
            }

            if( nEvent == 0 )iArg++;                                           // oskar 20061116

            // execute
            if( ((MyRealIEventHandler*) this)->pEventMap[iEvPos].pSelf )
               hb_vmSend( iArg );
            else
               hb_vmDo( iArg );

            if( nEvent == 0 )iArg--;                                           // oskar 20061116

            // release ref params
            for( i=iArg; i > 0; i-- )
            {
               if( (&(params->rgvarg[iArg-i]))->n1.n2.vt & VT_BYREF == VT_BYREF )
               {
                  switch( (&(params->rgvarg[iArg-i]))->n1.n2.vt )
                  {

                  //case VT_UI1|VT_BYREF:
                  //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pbVal) = va_arg(argList,unsigned char*);  //pItemArray[i-1]
                  //   break;
                  case VT_I2|VT_BYREF:
                     *((&(params->rgvarg[iArg-i]))->n1.n2.n3.piVal) = (short) hb_itemGetNI(pItemArray[i-1]);
                     break;
                  case VT_I4|VT_BYREF:
                     *((&(params->rgvarg[iArg-i]))->n1.n2.n3.plVal) = (long) hb_itemGetNL(pItemArray[i-1]);
                     break;
                  case VT_R4|VT_BYREF:
                     *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pfltVal) = (float) hb_itemGetND(pItemArray[i-1]);
                     break;
                  case VT_R8|VT_BYREF:
                     *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pdblVal) = (double) hb_itemGetND(pItemArray[i-1]);
                     break;
                  case VT_BOOL|VT_BYREF:
                     *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pboolVal) = hb_itemGetL( pItemArray[i-1] ) ? 0xFFFF : 0;
                     break;
                  //case VT_ERROR|VT_BYREF:
                  //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pscode) = va_arg(argList, SCODE*);
                  //   break;
                  case VT_DATE|VT_BYREF:
                     *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pdate) = (DATE) (double) (hb_itemGetDL(pItemArray[i-1])-2415019 ); //( (pItemArray[i-1])->item.asDate.value - 2415019 )
                     break;
                  //case VT_CY|VT_BYREF:
                  //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pcyVal) = va_arg(argList, CY*);
                  //   break;
                  //case VT_BSTR|VT_BYREF:
                  //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pbstrVal = va_arg(argList, BSTR*);
                  //   break;
                  //case VT_UNKNOWN|VT_BYREF:
                  //   pArg->ppunkVal = va_arg(argList, LPUNKNOWN*);
                  //   break;
                  //case VT_DISPATCH|VT_BYREF:
                  //   pArg->ppdispVal = va_arg(argList, LPDISPATCH*);
                  //   break;
                  }
               }
            }


            // return value? - no events are void functions
            //pItem = hb_param( -1, HB_IT_ANY) ;
            //hb_oleItemToVariant( result, pItem );

            hb_vmPopState();
            break;
         }
      }
   }

   return S_OK;
}


//------------------------------------------------------------------------------

// Here's IEventHandler's VTable. It never changes so we can declare it static

static const IEventHandlerVtbl IEventHandler_Vtbl = {
   QueryInterface,
   AddRef,
   Release,
   GetTypeInfoCount,
   GetTypeInfo,
   GetIDsOfNames,
   Invoke
};


// in xHarbour

//HRESULT hb_oleVariantToItem( PHB_ITEM pItem, VARIANT *pVariant )

#include <ocidl.h>

//------------------------------------------------------------------------------
// constructor
// params:
// device_interface        - refers to the interface type of the COM object (whose event we are trying to receive).
// device_event_interface  - indicates the interface type of the outgoing interface supported by the COM object.
//                           This will be the interface that must be implemented by the Sink object.
//                           is essentially derived from IDispatch, our Sink object (this IEventHandler)
//                           is also derived from IDispatch.


int LoadTypeInfo(IDispatch* pDisp);

typedef IEventHandler device_interface;

HRESULT SetupConnectionPoint(device_interface* pdevice_interface, REFIID riid, void** pThis, int* pn )
{
   IConnectionPointContainer*  pIConnectionPointContainerTemp = NULL;
   IDispatch*                  pIDispatchTemp = NULL;
   IUnknown*                   pIUnknown = NULL;
   IConnectionPoint*           m_pIConnectionPoint;
   IEnumConnectionPoints*      m_pIEnumConnectionPoints;
   HRESULT                     hr,r;
   IID                         rriid;
   register IEventHandler      *thisobj;
   DWORD                       dwCookie = 0;
   ITypeLib*                   pITypeLib;
   DISPID dispid;
   char cBuff[128];

   //IDispatch FAR* pdisp = NULL;

   // Allocate our IEventHandler object (actually a MyRealIEventHandler)
   if (!(thisobj = (IEventHandler *) GlobalAlloc(GMEM_FIXED, sizeof(MyRealIEventHandler))))
   {
      hr = E_OUTOFMEMORY;
   }
   else
   {

      // Store IExample3's VTable in the object
      thisobj->lpVtbl = (IEventHandlerVtbl *) &IEventHandler_Vtbl;

      // Increment the reference count so we can call Release() below and
      // it will deallocate only if there is an error with QueryInterface()
      ((MyRealIEventHandler *) thisobj)->count = 0;

      // Initialize any other members we added to the IEventHandler
      ((MyRealIEventHandler *) thisobj)->pSelf = NULL;
      ((MyRealIEventHandler *) thisobj)->pEventMap = NULL;
      ((MyRealIEventHandler *) thisobj)->iEventMapLen = 0;

      //((MyRealIEventHandler *) thisobj)->device_event_interface_iid = &riid;
      ((MyRealIEventHandler *) thisobj)->device_event_interface_iid = IID_IDispatch;

      // Query this object itself for its IUnknown pointer which will be used
      // later to connect to the Connection Point of the device_interface object.
      hr = thisobj->lpVtbl->QueryInterface( thisobj, &IID_IUnknown, (void**) &pIUnknown);

      if (hr == S_OK && pIUnknown)
      {

         /*
         // test to get type info
         hr = pdevice_interface->lpVtbl->QueryInterface( pdevice_interface, &IID_IDispatch, (void**) &pIDispatchTemp);
         if( hr == S_OK && pIDispatchTemp )
         {
            *pn = LoadTypeInfo( (IDispatch*) pIDispatchTemp);
            pIDispatchTemp->lpVtbl->Release( pIDispatchTemp);
         }
         */

         // Query the pdevice_interface for its connection point.
         hr = pdevice_interface->lpVtbl->QueryInterface( pdevice_interface, &IID_IConnectionPointContainer, (void**) &pIConnectionPointContainerTemp);

         if ( hr == S_OK && pIConnectionPointContainerTemp )
         {

            /*
            hr = pIConnectionPointContainerTemp->lpVtbl->EnumConnectionPoints(pIConnectionPointContainerTemp, &m_pIEnumConnectionPoints );
            if ( hr == S_OK && m_pIEnumConnectionPoints )
               do
               {
                  hr = m_pIEnumConnectionPoints->lpVtbl->Next( m_pIEnumConnectionPoints, 1, &m_pIconnectionPoint , NULL);
                  if( hr == S_OK )
                  {
                     if (m_pIConnectionPoint->lpVtbl->GetConnectionInterface( m_pIConnectionPoint, &pIID ) == S_OK )
                     {
                        ;


                     }

                  }

               } while( hr == S_OK )

               m_pIEnumConnectionPoints->lpVtbl->Release(m_pIEnumConnectionPoints);
            }
            */

            hr = pIConnectionPointContainerTemp ->lpVtbl->FindConnectionPoint(pIConnectionPointContainerTemp ,  &IID_IDispatch, &m_pIConnectionPoint);
            pIConnectionPointContainerTemp->lpVtbl->Release( pIConnectionPointContainerTemp );
            pIConnectionPointContainerTemp = NULL;
         }

         if (hr == S_OK && m_pIConnectionPoint )
         {

            /*
            hr = m_pIConnectionPoint->lpVtbl->QueryInterface( m_pIConnectionPoint, &IID_IDispatch, (void**) &pIDispatchTemp);
            if( hr == S_OK && pIDispatchTemp )
            {

               *pn = LoadTypeInfo( (IDispatch*) pIDispatchTemp);

               pIDispatchTemp->lpVtbl->Release( pIDispatchTemp);
            }
            */


            //OutputDebugString("getting iid");
            //Returns the IID of the outgoing interface managed by this connection point.
            hr = m_pIConnectionPoint->lpVtbl->GetConnectionInterface(m_pIConnectionPoint, &rriid );
            //OutputDebugString("called");


            if( hr == S_OK )
            {
               ((MyRealIEventHandler *) thisobj)->device_event_interface_iid = rriid;
            }
            else
               OutputDebugString("error getting iid");


            /*
            hr = thisobj->lpVtbl->QueryInterface( thisobj, &IID_IDispatch, (void**) &pdisp);
            if ( hr == S_OK )
            {
            dispid   = 0;
            hr = pdisp->lpVtbl->GetIDsOfNames(pdisp, &IID_NULL,  &szMember,  1, LOCALE_SYSTEM_DEFAULT, &dispid);
            wsprintf( cBuff, "Id: %i, Status %i", dispid, hr ) ;
            OutputDebugString(cBuff);
            }
            */

            //OutputDebugString("calling advise");
            hr = m_pIConnectionPoint->lpVtbl->Advise(m_pIConnectionPoint, pIUnknown, &dwCookie );
            ((MyRealIEventHandler *) thisobj)->pIConnectionPoint = m_pIConnectionPoint;
            ((MyRealIEventHandler *) thisobj)->dwEventCookie = dwCookie;

         }

         pIUnknown->lpVtbl->Release(pIUnknown);
         pIUnknown = NULL;
      }
   }

   *pThis = (void*) thisobj;
   return hr;

}


//------------------------------------------------------------------------------
//destructor

void ShutdownConnectionPoint(MyRealIEventHandler *this)
{

    if (this->pIConnectionPoint)
    {
       this->pIConnectionPoint->lpVtbl->Unadvise(this->pIConnectionPoint, this->dwEventCookie);
       this->dwEventCookie = 0;
       this->pIConnectionPoint->lpVtbl->Release(this->pIConnectionPoint);
       this->pIConnectionPoint = NULL;
    }
}


//*****************
// helper functions
//*****************


/*

//---------------------------------------------------------------------------//
HB_EXPORT BSTR hb_oleAnsiToSysString( LPSTR cString )
{
   int nConvertedLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cString, -1, NULL, 0 );

   if( nConvertedLen )
   {
      BSTR bstrString = SysAllocStringLen( NULL, nConvertedLen - 1 );

      if( MultiByteToWideChar( CP_ACP, 0, cString, -1, bstrString, nConvertedLen ) )
      {
         return bstrString;
      }
      else
      {
         SysFreeString( bstrString );
      }
   }
   return NULL;
}

*/


//------------------------------------------------------------------------------

HB_FUNC(SHUTDOWNCONNECTIONPOINT)
{
   ShutdownConnectionPoint( (MyRealIEventHandler*) hb_parnl(1));
}

//------------------------------------------------------------------------------

// SetupConnectionPoint( hOleObj, @hSink ) // ::cClassname, @::hSink, EvMapArray, oObj )

HB_FUNC( SETUPCONNECTIONPOINT)
{

   HRESULT              hr;
   MyRealIEventHandler* hSink    = NULL;
   LPIID                riid     = (LPIID) &IID_IDispatch;
   int                  n;

   hr = SetupConnectionPoint( (device_interface*) hb_parnl(1), (REFIID) riid, (void**) &hSink, &n  ) ;
   hb_stornl((LONG) hSink, 2);
   hb_storni(n, 3);
   hb_retnl(hr);

}

//------------------------------------------------------------------------------

void UnBindEvents(  MyRealIEventHandler* hSink )
{

   if( hSink )
   {

      if( hSink->pEventMap )
      {
          hb_xfree( hSink->pEventMap );
          hSink->pEventMap = NULL;
          hSink->iEventMapLen = 0;
          if( hSink->pSelf )
               hb_itemRelease( hSink->pSelf );
          hSink->pSelf = NULL;
      }

   }

}


//------------------------------------------------------------------------------

//BindEvents( hSink, EvMapArray, oObj ) -> NIL ?

HB_FUNC( BINDEVENTS )
{

   PHB_ITEM             pArray;
   PHB_ITEM             pSubArray;
   PHB_ITEM             pSelf;
   ULONG                uiLen;
   ULONG                i;
   MyRealIEventHandler* hSink;

   hSink = (MyRealIEventHandler*) hb_parnl(1);

   if( hSink)
   {

      // clear any old map
      UnBindEvents(hSink);

      // create new map
      pArray = hb_param( 2, HB_IT_ARRAY );
      if( pArray && (uiLen = hb_arrayLen( pArray )) > 0 )
      {
         if( ISOBJECT( 3 ) )
         {
            pSelf = hb_itemNew( hb_param( 3, HB_IT_OBJECT ) );
         }
         else
         {
            pSelf = NULL;
         }
         hSink->pSelf = pSelf;

         hSink->pEventMap = (EventMap*) hb_xgrab( uiLen * sizeof(EventMap));
         hSink->iEventMapLen = uiLen;

         for( i = 0; i< uiLen; i++ )
         {
            pSubArray = hb_arrayGetItemPtr( pArray, i+1 ); // 1 based ???

            if( pSubArray && HB_IS_ARRAY( pSubArray )) // && (hb_arrayLen( pSubArray ) > 1) )
            {

               hSink->pEventMap[i].dispid  = (DISPID) hb_arrayGetNL( pSubArray, 1 );

               if( HB_IS_BLOCK( hb_arrayGetItemPtr( pSubArray, 2 ) ) )
               {
                  hSink->pEventMap[i].pSymbol = hb_dynsymGet( "EVAL" );
                  hSink->pEventMap[i].pSelf   = hb_itemNew( hb_arrayGetItemPtr( pSubArray, 2 ) );
               }
               else
               {
                  hSink->pEventMap[i].pSelf   = pSelf;
                  if( HB_IS_STRING( hb_arrayGetItemPtr( pSubArray, 2 ) ) )
                      hSink->pEventMap[i].pSymbol = hb_dynsymGet( hb_itemGetC( hb_arrayGetItemPtr( pSubArray, 2 ) ) );

                  else if( HB_IS_POINTER( hb_arrayGetItemPtr( pSubArray, 2 ) ) )
                      hSink->pEventMap[i].pSymbol = ( ( PHB_SYMB ) hb_arrayGetItemPtr( pSubArray, 2 ) )->pDynSym;

                  else  // bad PRG handler
                  {
                      hb_errRT_BASE_SubstR( EG_ARG, 1, NULL, "BindEvents", 3, hb_paramError( 1 ), hb_paramError( 2 ), hb_paramError( 3 ) );
                      return;
                  }
               }
            }
            else // bad array element
            {
               hb_errRT_BASE_SubstR( EG_ARG, 1, NULL, "BindEvents", 3, hb_paramError( 1 ), hb_paramError( 2 ), hb_paramError( 3 ) );
               return;
            }
         }
      }
   }
   else // invalid sink object
   {
      hb_errRT_BASE_SubstR( EG_ARG, 1, NULL, "BindEvents", 3, hb_paramError( 1 ), hb_paramError( 2 ), hb_paramError( 3 ) );
      return;
   }
}


//------------------------------------------------------------------------------

// UnbindEvents(hSink)

HB_FUNC( UNBINDEVENTS )
{

   MyRealIEventHandler* hSink = (MyRealIEventHandler*) hb_parnl(1);

   if( hSink )
   {
    UnBindEvents( hSink );
   }
   else // invalid sink object
   {
      hb_errRT_BASE_SubstR( EG_ARG, 1, NULL, "UnBindEvents", 3, hb_paramError( 1 ), hb_paramError( 2 ), hb_paramError( 3 ) );
   }

}


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


