#Requires AutoHotkey v2.0
#SingleInstance Force

nombre_valor := [
    ["AGUSTO MANUEL DE AVILA BORJA", "100,000"],
    ["ALFONSO DELGADO LOZANO", "70,000"],
    ["ALFONSO ALFREDO ALVARADO MENDOZA", "70,000"],
    ["ALVARO ANTONIO BERNAL CORREA", "70,000"],
    ["ANA GREGORIA MEJIA ARRIETA", "70,000"],
    ["ANA VICENTA GARIZABALO DE LA CRUZ", "70,000"],
    ["ANABEL JARABA GONZALEZ", "70,000"],
    ["ANGELA CHARRIS LEONES", "70,000"],
    ["ANGELY PAOLA CARRIZO VILORIA", "70,000"],
    ["ANYELLA PATRICIA PINO CABALLERO", "70,000"],
    ["BEATRIZ BRAFFI GUTIERREZ", "70,000"],
    ["EDGAR RAFAEL VILLARREAL BORJA", "70,000"],
    ["EDIOVANIS GARIZABALO DE LA CRUZ", "70,000"],
    ["ESTEBAN SANDOVAL MALDONADO", "70,000"],
    ["FERNANDO ANTONIO SOLANO FERNANDEZ", "70,000"],
    ["FRANCISCO JAVIER HERRERA CORTEZ", "70,000"],
    ["FRANKLIN MARTIN RANGEL RADA", "70,000"],
    ["FREDDY ALFONSO PAREJO PEREZ", "70,000"],
    ["GUSTAVO LEON MARTINEZ", "70,000"],
    ["JAVIER ENRIQUE MORALES JIMENEZ", "80,000"],
    ["JENIR DEL CARMEN JARABA GONZALEZ", "70,000"],
    ["JHONATAN VILLA FERNANDEZ", "70,000"],
    ["JOAQUÍN MARCIAL OROZCO DE LOS REYES", "100,000"],
    ["JOSE CENICO SAAVEDRA SALCEDO", "70,000"],
    ["JUAN ANTONIO VEGA RODRIGUEZ", "70,000"],
    ["JULIO CESAR GUTIERREZ VALDES", "70,000"],
    ["LILIANA CRISTINA HERNANDEZ VEGA", "70,000"],
    ["LORENZA FERNANDEZ VILLARREAL", "100,000"],
    ["LUIS ALBERTO HERNANDEZ", "70,000"],
    ["LUIS CARLOS DE MOYA", "70,000"],
    ["MARAIT ZULAIT SIERRA ZAMBRANO", "70,000"],
    ["MARELVIS JUDITH GARIZABALO DE LA CRUZ", "70,000"],
    ["MARIA DEL CARMEN VILLA FERNANDEZ", "70,000"],
    ["MARTHA CECILIA CORRALES", "70,000"],
    ["MONICA PATRICIA VILLAMIL PUELLO", "70,000"],
    ["NESTOR RAMÓN ACENDRA ACENDRA", "70,000"],
    ["OMAR DE JESUS ACUÑA ROBLES", "70,000"],
    ["OSCAR JESUS HERNANDEZ NAVARRO", "70,000"],
    ["PABLO CASTILLA SUAREZ", "80,000"],
    ["RAFAEL FONTALVO FERRER", "70,000"],
    ["RAUL ALBERTO VISBAL MONTERO", "70,000"],
    ["RAUL ANTONIO DE LA ROSA MEJÍA", "70,000"],
    ["REYES MARIA RODRIGUEZ MARIN", "70,000"],
    ["RICARDO DAVID VEGA REALES", "70,000"],
    ["ROBERTO MANUEL VALVERDE CUENTAS", "70,000"],
    ["RUTH MARINA RUA MARIN", "70,000"],
    ["SERGIO ANDRES LOPEZ CAMACHO", "70,000"],
    ["STEVEN FRIAS MARTINEZ", "70,000"],
    ["TULA ISABEL CAMARGO ALVARADO", "80,000"],
    ["TULIA ROSA RODELO DIAZ", "70,000"],
    ["VICTOR ALFONSO CASTRO GRANADILLO", "70,000"],
    ["WENDY MARIA NIEBLES RAMIREZ", "70,000"],
    ["WILLIAM BERDUGO CASTRO", "70,000"],
    ["YAIR JOSE RUA GARIZABALO", "70,000"],
    ["YEISON ROBERTO LOPEZ CAMACHO", "70,000"],
    ["YENELKY JARABA GONZALEZ", "70,000"],
    ["YESID FERRER ROBLES", "70,000"],
    ["YIDI PAOLA DOMINGUEZ VILLALOBOS", "70,000"],
    ["YOMAIRA PEREZ", "70,000"],
    ["YOSETH DAVID COLMENARES ACEVEDO", "70,000"]
]

indice := 1

F1::
{
    global indice, nombre_valor

    if indice > nombre_valor.Length {
        MsgBox "Ya se procesaron todos los registros!!!"
        return
    }

    nombre := nombre_valor[indice][1]
    valor := nombre_valor[indice][2]
    
    ; FECHA
        Send "12/02/2025"
        Sleep 500

        Send "{Tab}"
        Sleep 100
    
    ; MES  
        Send "^a"
        Sleep 100

        SendText "AGO"
        Sleep 100

        Send "{Tab}"
        Sleep 100
    
    ; AÑO  
        Send "^a"
        Sleep 100

        SendText "2024"
        Sleep 100

        Send "{Tab}"
        Sleep 100
    
    ; NOMBRE   
        SendText nombre    
        Sleep 3000

        Send "{Tab}"
        Sleep 350     

    Loop 7
    {
        Send "{Tab}"
        Sleep 100
    }  
    
    Send "{Enter}"
    Sleep 150    

    Send "{Down}"
    Sleep 100
    Send "{Down}"
    Sleep 100    

    Send "{Tab}"
    Sleep 100

    Send "{Tab}"
    Sleep 100    

    ; CODIGO
        SendText "51350502"
        Sleep 500    
    
    Loop 6
    {
        Send "{Tab}"
        Sleep 250
    }    

    Send valor
    Sleep 100

    Loop 6
    {
        Send "{Tab}"
        Sleep 100
    }  

    indice++
}