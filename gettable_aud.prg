// Programa   : GETTABLE_AUD
// Fecha/Hora : 10/09/2014 00:52:15
// Prop�sito  : Obtener Nombre de la Tabla de Auditor�a
// Creado Por : Juan Navas
// Llamado por:
// Aplicaci�n :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cTable)
  LOCAL cTableAud:="DPAUDITAELIMOD"
  LOCAL cDb
  
  DEFAULT cTable:="DPUSUARIOS"

  SETDBSERVER() // Resetea la asignaci�n de la Base de datos.

  cDb:=SQLGET("DPTABLAS","TAB_DSN","TAB_NOMBRE"+GetWhere("=",cTable))
  
  IF "."=LEFT(cDb,1)
     cTableAud:="DPAUDELIMODCNF"
  ENDIF

  IF "-"=LEFT(cDb,1)
     cTableAud:="DPAUDELIMODDIC"
  ENDIF

RETURN cTableAud
// EOF


