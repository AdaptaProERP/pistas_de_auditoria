// Programa   : DPAUDELIMOD
// Fecha/Hora : 04/03/2008 23:51:06
// Propósito  : Registrar Eliminación y Modificación Versión Modificar
// Creado Por : Juan Navas
// Llamado por: Formularios
// Aplicación : 
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(oFrm,cPrimary,oTable,cKey,nOption)
   LOCAL I,cMemo:="",cField,uValue,uValueOld,cOption,n,cTable,nLen
   LOCAL cTableAud:=""

   IF ValType(oFrm)="O"

     oTable  :=oFrm:oTable

     IF oTable=NIL .OR. Empty(oTable:aFields)
        RETURN NIL
     ENDIF

     // Desde Formulario

     DEFAULT cKey:=oTable:cPrimary

     cTable  :=oTable:cTable

     
     DEFAULT cPrimary:=oTable:GetDataKey(NIL,cKey)

// ? cPrimary,"cPrimary",cKey,"cKey"

     cOption :=IF(oFrm:nOption=3,"M","E")
     nOption :=oFrm:nOption

     IF nOption=3 
  
       FOR n=1 TO LEN(oTable:aFields)

         cField   :=oTable:aFields[n,1] 
         uValue   :=oFrm:Get(cField)
         uValueOld:=oFrm:Get(cField+"_")

// ? oTable:aFields[n,2],I,cField,"cField",uValue
         // oDp:oFrameDp:Settext(CTOO(uValue,"C")+","+cField+", cField")

         // Resuelve Campos ComboBox mediante clase TSCROLLGET JN 28/08/2014
         IF oTable:aFields[n,2]="C" .AND. ValType(uValueOld)=ValType(uValue) .AND. ValType(uValue)="C"
            uValueOld:=ALLTRIM(LEFT(uValueOld,oTable:aFields[n,3]))
            uValue   :=ALLTRIM(LEFT(uValue   ,oTable:aFields[n,3]))
         ENDIF

         IF oTable:aFields[n,2]="M" .AND. ValType(uValue)="C"

            uValueOld:=ALLTRIM(uValueOld)
            uValue   :=ALLTRIM(uValue   )

            IF !uValueOld==uValue
              uValue:=cField+"="+CTOO(uValueOld,"C")+CHR(9)+" "+CTOO(uValue,"C")
              cMemo:=cMemo+IF(Empty(cMemo),"",CRLF)+uValue
            ENDIF

         ENDIF

         IF (ValType(uValue)=ValType(uValueOld)) .AND. !(uValue==uValueOld) 
            uValue:=cField+"="+CTOO(uValueOld,"C")+CHR(9)+" "+CTOO(uValue,"C")
            cMemo:=cMemo+IF(Empty(cMemo),"",CRLF)+uValue
         ENDIF
 
       NEXT 

      ELSE

       cMemo:=REGELIMINAR()

      ENDIF

    ELSE

      cTable:=OTable:cTable

      cMemo:=REGELIMINAR(oTable)

   ENDIF

   cTableAud:=EJECUTAR("GETTABLE_AUD",cTable)

   IF Empty(cTableAud)
      MsgMemo("No fue encontrada tabla de Auditoria para "+cTable)
      RETURN .F.
   ENDIF
  

  IF !Empty(cMemo)

      oTable:=OpenTable("SELECT * FROM "+cTableAud,.F.)
      oTable:AppendBlank()
      oTable:Replace("AEM_TABLA" ,cTable       )
      oTable:Replace("AEM_CLAVE" ,cPrimary     )
      oTable:Replace("AEM_KEY"   ,cKey         )
      oTable:Replace("AEM_OPCION","M"          )
      oTable:Replace("AEM_FECHA" ,oDp:dFecha   )
      oTable:Replace("AEM_HORA"  ,TIME()       )
      oTable:Replace("AEM_MEMO"  ,cMemo        )
      oTable:Replace("AEM_ESTACI",oDp:cPcName  )
      oTable:Replace("AEM_IP"    ,oDp:cIpLocal )
      oTable:Replace("AEM_USUARI",oDp:cUsuario )
      oTable:Commit()
      oTable:End()

   ENDIF

RETURN .T.

FUNCTION REGELIMINAR(oTable)
  LOCAL cMemo:="",I,lClose:=.F.

  IF oTable=NIL
    oTable:=OpenTable("SELECT * FROM "+cTable+ " WHERE "+cKey+GetWhere("=",cPrimary),.T.) 
    lClose:=.T.
  ENDIF

  FOR I=1 TO oTable:Fcount()

      cMemo:=cMemo + IF(Empty(cMemo), "", CRLF )+;
             oTable:FieldName(I)+"="+CTOO(oTable:FieldGet(I),"C")

  NEXT I

  IF lClose
    oTable:End()
  ENDIF
  
RETURN cMemo
// EOF

