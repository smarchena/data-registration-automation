#Requires AutoHotkey v2.0
#SingleInstance Force

materiales := [
    ["ACRI001", "120"],
    ["CHATALUMINIO001", "4000"],
    ["ARCHIVO001", "500"],
    ["CARTON001", "180"],
    ["CHATCHIERRO001", "450"],
    ["PyC01", "530"],
    ["PYC02", "95"],
    ["PLASPL01", "200"],
    ["PL02", "550"],
    ["OTROSV01", "110"],
    ["PASTA001", "550"],
    ["PETACEITE001", "180"],
    ["PETAMBAR001", "300"],
    ["PETTRANSP001", "900"],
    ["PETVERDE001", "180"],
    ["PLASTBCO", "400"],
    ["PLASTICO001", "400"],
    ["PLEGA001", "150"],
    ["PVC001", "250"],
    ["SILLPL01", "1300"],
    ["SOP031", "500"],
    ["TAPPLAS01", "400"],
    ["TETRAPACK001", "150"],
    ["VIDAMBAR001", "130"],
    ["VIDENVASE001", "130"]
]

cantidades := []
detenerProceso := false
procesoActivo := false

ventana := Gui(, "Automatizador de materiales")
ventana.SetFont("s10", "Segoe UI")

ventana.AddText("x20 y20 w500 Center", "AUTOMATIZADOR DE MATERIALES")
ventana.AddText("x20 y60 w500", "Pegue las cantidades, una por línea:")

campoCantidades := ventana.AddEdit(
    "x20 y85 w500 h250 Multi WantReturn VScroll"
)

contador := ventana.AddText(
    "x20 y350 w500 Center",
    "Registros detectados: 0 / 25"
)

botonValidar := ventana.AddButton(
    "x20 y390 w150 h40",
    "Validar"
)

botonIniciar := ventana.AddButton(
    "x195 y390 w150 h40 Disabled",
    "Iniciar"
)

botonDetener := ventana.AddButton(
    "x370 y390 w150 h40 Disabled",
    "Detener"
)

estado := ventana.AddText(
    "x20 y450 w500 Center",
    "Estado: Esperando cantidades"
)

barraProgreso := ventana.AddProgress(
    "x20 y480 w500 h25 Range0-25",
    0
)

ventana.OnEvent("Close", CerrarPrograma)

botonValidar.OnEvent("Click", ValidarCantidades)
botonIniciar.OnEvent("Click", IniciarProceso)
botonDetener.OnEvent("Click", SolicitarDetencion)

campoCantidades.OnEvent("Change", ContarRegistros)

ventana.Show("w540 h530")

ContarRegistros(*)
{
    global campoCantidades, contador

    texto := Trim(campoCantidades.Value)

    if (texto = "")
    {
        contador.Text := "Registros detectados: 0 / 25"
        return
    }

    lineas := StrSplit(texto, "`n", "`r")
    registrosValidos := 0

    for linea in lineas
    {
        if (Trim(linea) != "")
            registrosValidos++
    }

    contador.Text := "Registros detectados: " registrosValidos " / 25"
}

ValidarCantidades(*)
{
    global campoCantidades, cantidades
    global contador, estado, botonIniciar

    texto := Trim(campoCantidades.Value)

    if (texto = "")
    {
        MsgBox(
            "No se encontraron cantidades.",
            "Error",
            "Icon!"
        )
        return
    }

    lineas := StrSplit(texto, "`n", "`r")
    cantidadesTemporales := []

    for linea in lineas
    {
        valor := Trim(linea)

        if (valor != "")
            cantidadesTemporales.Push(valor)
    }

    if (cantidadesTemporales.Length != 25)
    {
        MsgBox(
            "Se detectaron " cantidadesTemporales.Length " cantidades.`n`nDebes pegar exactamente 25 cantidades.",
            "Cantidad incorrecta",
            "Icon!"
        )

        estado.Text := "Estado: Cantidad de registros incorrecta"
        botonIniciar.Enabled := false
        return
    }

    for indice, cantidad in cantidadesTemporales
    {
        cantidadNormalizada := StrReplace(cantidad, ",", ".")

        if !RegExMatch(cantidadNormalizada, "^\d+(\.\d+)?$")
        {
            MsgBox(
                "La línea " indice " contiene un valor no válido:`n`n" cantidad,
                "Cantidad inválida",
                "Icon!"
            )

            estado.Text := "Estado: Error en la línea " indice
            botonIniciar.Enabled := false
            return
        }

        cantidadesTemporales[indice] := cantidadNormalizada
    }

    cantidades := cantidadesTemporales

    contador.Text := "Registros detectados: 25 / 25"
    estado.Text := "Estado: Cantidades validadas correctamente"
    botonIniciar.Enabled := true

    MsgBox(
        "Las 25 cantidades son válidas.`n`nYa puedes presionar Iniciar.",
        "Validación correcta",
        "Iconi"
    )
}

IniciarProceso(*)
{
    global cantidades, procesoActivo, detenerProceso
    global campoCantidades, botonValidar
    global botonIniciar, botonDetener
    global estado, barraProgreso

    if (cantidades.Length != 25)
    {
        MsgBox(
            "Primero debes validar las cantidades.",
            "Validación requerida",
            "Icon!"
        )
        return
    }

    procesoActivo := true
    detenerProceso := false

    campoCantidades.Enabled := false
    botonValidar.Enabled := false
    botonIniciar.Enabled := false
    botonDetener.Enabled := true

    barraProgreso.Value := 0

    Loop 5
    {
        if (detenerProceso)
        {
            FinalizarProceso("Proceso detenido antes de comenzar")
            return
        }

        segundosRestantes := 6 - A_Index

        estado.Text := "Estado: Comenzando en " segundosRestantes " segundos..."

        Sleep 1000
    }

    estado.Text := "Estado: Automatización iniciada"

    EjecutarAutomatizacion()
}

EjecutarAutomatizacion()
{
    global materiales, cantidades
    global detenerProceso, estado, barraProgreso

    Loop 25
    {
        if (detenerProceso)
        {
            FinalizarProceso("Proceso detenido en el producto " A_Index " de 25")
            return
        }

        indice := A_Index

        estado.Text := "Estado: Procesando producto " indice " de 25"

        barraProgreso.Value := indice - 1

        Sleep 100

        if (indice >= 6 && indice <= 10)
        {
            SendText materiales[indice][1]

            if !EsperarConDetencion(1000)
                return

            Send "{Tab}"

            if !EsperarConDetencion(100)
                return

            Send "^a"

            if !EsperarConDetencion(150)
                return

            SendText cantidades[indice]

            if !EsperarConDetencion(150)
                return

            Send "{Tab}"

            if !EsperarConDetencion(150)
                return

            SendText materiales[indice][2]

            if !EsperarConDetencion(300)
                return
        }
        else
        {
            SendText materiales[indice][1]

            if !EsperarConDetencion(1000)
                return

            Loop 5
            {
                Send "{Tab}"

                if !EsperarConDetencion(100)
                    return
            }

            if !EsperarConDetencion(150)
                return

            SendText cantidades[indice]

            if !EsperarConDetencion(150)
                return

            Send "{Tab}"

            if !EsperarConDetencion(150)
                return

            SendText materiales[indice][2]

            if !EsperarConDetencion(300)
                return
        }

        Loop 5
        {
            Send "{Tab}"

            if !EsperarConDetencion(100)
                return
        }

        barraProgreso.Value := indice

        if (indice = 10 || indice = 24)
        {
            estado.Text := "Estado: Bajando la página"

            Send "{PgDn}"

            if !EsperarConDetencion(100)
                return
        }

        if (indice < 25)
        {
            estado.Text := "Estado: Producto " indice " completado. Preparando el siguiente..."

            if !EsperarConDetencion(100)
                return
        }
    }

    FinalizarProceso("Proceso terminado correctamente")
}

EsperarConDetencion(tiempo)
{
    global detenerProceso

    tiempoTranscurrido := 0

    while (tiempoTranscurrido < tiempo)
    {
        if (detenerProceso)
        {
            FinalizarProceso("Proceso detenido por el usuario")
            return false
        }

        intervalo := Min(100, tiempo - tiempoTranscurrido)

        Sleep intervalo

        tiempoTranscurrido += intervalo
    }

    return true
}

SolicitarDetencion(*)
{
    global detenerProceso, estado

    detenerProceso := true

    estado.Text := "Estado: Deteniendo proceso..."
}

FinalizarProceso(mensaje)
{
    global procesoActivo, detenerProceso
    global campoCantidades, botonValidar
    global botonIniciar, botonDetener
    global estado

    procesoActivo := false
    detenerProceso := false

    campoCantidades.Enabled := true
    botonValidar.Enabled := true
    botonDetener.Enabled := false

    estado.Text := "Estado: " mensaje

    if (mensaje = "Proceso terminado correctamente")
    {
        MsgBox(
            "Los 25 productos fueron procesados.",
            "Proceso terminado",
            "Iconi"
        )
    }
}

CerrarPrograma(*)
{
    global procesoActivo

    if (procesoActivo)
    {
        respuesta := MsgBox(
            "Hay una automatización en ejecución.`n`n¿Deseas cerrar el programa?",
            "Confirmar cierre",
            "YesNo Icon!"
        )

        if (respuesta = "No")
            return
    }

    ExitApp
}
