#Requires AutoHotkey v2.0
#SingleInstance Force


; ============================================================
; VARIABLES
; ============================================================

nombre_valor := []

indice := 1


; ============================================================
; INTERFAZ
; ============================================================

miGui := Gui("+Resize", "Automatización")

miGui.SetFont("s10", "Segoe UI")


; ============================================================
; FECHA
; ============================================================

miGui.AddText(
    "x20 y20",
    "Ingrese fecha:"
)

txtFecha := miGui.AddEdit(
    "x20 y45 w150 h30",    
)


; ============================================================
; NOMBRES
; ============================================================

miGui.AddText(
    "x20 y95",
    "Nombres:"
)

txtNombres := miGui.AddEdit(
    "x20 y120 w350 h350 Multi"
)


; ============================================================
; VALORES
; ============================================================

miGui.AddText(
    "x390 y95",
    "Valores:"
)

txtValores := miGui.AddEdit(
    "x390 y120 w150 h350 Multi"
)


; ============================================================
; BOTÓN CARGAR DATOS
; ============================================================

btnCargar := miGui.AddButton(
    "x20 y490 w150 h40",
    "Cargar datos"
)

btnCargar.OnEvent(
    "Click",
    CargarDatos
)


; ============================================================
; BOTÓN CONTINUAR
; ============================================================

btnContinuar := miGui.AddButton(
    "x190 y490 w150 h40",
    "Continuar"
)

btnContinuar.OnEvent(
    "Click",
    ContinuarRegistro
)


; ============================================================
; INFORMACIÓN DEL REGISTRO
; ============================================================

lblRegistro := miGui.AddText(
    "x20 y545 w520 h30",
    "Registro actual: 0"
)


lblEstado := miGui.AddText(
    "x20 y575 w520 h30",
    "Esperando datos..."
)


; ============================================================
; MOSTRAR INTERFAZ
; ============================================================

miGui.Show(
    "w570 h620"
)


; ============================================================
; CARGAR DATOS
; ============================================================

CargarDatos(*)
{
    global txtNombres
    global txtValores
    global nombre_valor
    global indice
    global lblRegistro
    global lblEstado


    ; --------------------------------------------------------
    ; OBTENER TEXTO
    ; --------------------------------------------------------

    nombresTexto := txtNombres.Value
    valoresTexto := txtValores.Value


    ; --------------------------------------------------------
    ; SEPARAR POR LÍNEAS
    ; --------------------------------------------------------

    nombres := StrSplit(
        nombresTexto,
        "`n",
        "`r"
    )

    valores := StrSplit(
        valoresTexto,
        "`n",
        "`r"
    )


    ; --------------------------------------------------------
    ; COMPROBAR CANTIDADES
    ; --------------------------------------------------------

    if nombres.Length != valores.Length
    {
        MsgBox(
            "La cantidad de nombres y valores no coincide.`n`n"
            . "Nombres: " nombres.Length "`n"
            . "Valores: " valores.Length,
            "Error",
            "Iconx"
        )

        return
    }


    ; --------------------------------------------------------
    ; LIMPIAR ARRAY
    ; --------------------------------------------------------

    nombre_valor := []

    indice := 1


    ; --------------------------------------------------------
    ; CREAR ASOCIACIÓN
    ; --------------------------------------------------------

    Loop nombres.Length
    {
        nombre := Trim(
            nombres[A_Index]
        )

        valor := Trim(
            valores[A_Index]
        )


        ; Ignorar líneas vacías

        if nombre = "" && valor = ""
        {
            continue
        }


        nombre_valor.Push(
            [
                nombre,
                valor
            ]
        )
    }


    ; --------------------------------------------------------
    ; COMPROBAR DATOS
    ; --------------------------------------------------------

    if nombre_valor.Length = 0
    {
        MsgBox(
            "No hay datos para cargar.",
            "Aviso",
            "Icon!"
        )

        return
    }


    ; --------------------------------------------------------
    ; ACTUALIZAR INTERFAZ
    ; --------------------------------------------------------

    lblRegistro.Text :=
        "Registro actual: 1 / "
        . nombre_valor.Length

    lblEstado.Text :=
        "Datos cargados correctamente."


    MsgBox(
        "Datos cargados correctamente.`n`n"
        . "Registros: "
        . nombre_valor.Length
        . "`n`n"
        . "Presiona F1 para procesar el registro actual.",
        "Listo",
        "Iconi"
    )
}


; ============================================================
; F1 - PROCESAR REGISTRO ACTUAL
; ============================================================

F1::
{
    global indice
    global nombre_valor
    global txtFecha
    global lblRegistro
    global lblEstado


    ; --------------------------------------------------------
    ; COMPROBAR DATOS
    ; --------------------------------------------------------

    if nombre_valor.Length = 0
    {
        MsgBox(
            "Primero debes cargar los datos.",
            "Aviso",
            "Icon!"
        )

        return
    }


    ; --------------------------------------------------------
    ; COMPROBAR SI TERMINÓ
    ; --------------------------------------------------------

    if indice > nombre_valor.Length
    {
        MsgBox(
            "Ya se procesaron todos los registros!!!",
            "Proceso terminado",
            "Iconi"
        )

        return
    }


    ; --------------------------------------------------------
    ; OBTENER REGISTRO ACTUAL
    ; --------------------------------------------------------

    nombre :=
        nombre_valor[indice][1]

    valor :=
        nombre_valor[indice][2]

    fecha :=
        txtFecha.Value


    ; --------------------------------------------------------
    ; MOSTRAR REGISTRO
    ; --------------------------------------------------------

    lblRegistro.Text :=
        "Registro actual: "
        . indice
        . " / "
        . nombre_valor.Length

    lblEstado.Text :=
        "Procesando: "
        . nombre


    ; ========================================================
    ; AUTOMATIZACIÓN
    ; ========================================================

    Click 314, 252
    Sleep 100


    Send "{Down}"
    Sleep 100

    Send "{Enter}"
    Sleep 1000


    ; --------------------------------------------------------
    ; NOMBRE
    ; --------------------------------------------------------

    SendText nombre
    Sleep 2000


    Click 275, 334
    Sleep 500


    ; --------------------------------------------------------
    ; TAB
    ; --------------------------------------------------------

    Send "{Tab}"
    Sleep 500


    ; --------------------------------------------------------
    ; FECHA
    ; --------------------------------------------------------

    Send fecha
    Sleep 200


    ; --------------------------------------------------------
    ; TAB
    ; --------------------------------------------------------

    Send "{Tab}"
    Sleep 800

    Send "{Tab}"
    Sleep 1000


    ; --------------------------------------------------------
    ; CLICK
    ; --------------------------------------------------------

    Click 261, 449
    Sleep 500


    ; --------------------------------------------------------
    ; VALOR
    ; --------------------------------------------------------

    Send "{Tab}"
    Sleep 100

    Send valor
    Sleep 500

    Click 143, 541, 2

    ; --------------------------------------------------------
    ; REGISTRO TERMINADO
    ; --------------------------------------------------------

    lblEstado.Text :=
        "Completado: "
        . nombre
        . "`nPresiona F1 para repetir o Continuar para avanzar."
}


; ============================================================
; CONTINUAR - SIGUIENTE REGISTRO
; ============================================================

ContinuarRegistro(*)
{
    global indice
    global nombre_valor
    global lblRegistro
    global lblEstado


    ; --------------------------------------------------------
    ; COMPROBAR DATOS
    ; --------------------------------------------------------

    if nombre_valor.Length = 0
    {
        MsgBox(
            "Primero debes cargar los datos.",
            "Aviso",
            "Icon!"
        )

        return
    }


    ; --------------------------------------------------------
    ; COMPROBAR SI YA ESTÁ EN EL ÚLTIMO
    ; --------------------------------------------------------

    if indice >= nombre_valor.Length
    {
        MsgBox(
            "Este es el último registro.`n`n"
            . "Ya no hay más registros para continuar.",
            "Fin",
            "Iconi"
        )

        return
    }


    ; --------------------------------------------------------
    ; AUMENTAR ÍNDICE
    ; --------------------------------------------------------

    indice++


    ; --------------------------------------------------------
    ; ACTUALIZAR INTERFAZ
    ; --------------------------------------------------------

    lblRegistro.Text :=
        "Registro actual: "
        . indice
        . " / "
        . nombre_valor.Length


    lblEstado.Text :=
        "Listo para procesar: "
        . nombre_valor[indice][1]
}