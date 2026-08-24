extends Node

#mensajero para conectar vida_jugador a UI_vida_jugador
@warning_ignore("unused_signal")
signal Cambio_vida( vida : int )

#mensajero para conectar de Maxima_vida_jugador a cantidad de corazones del UI
@warning_ignore("unused_signal")
signal Max_corazones( max_vida : int )

#mensajero para conectar el area/calor de la patasca a la barra_UI_zona_segura
@warning_ignore("unused_signal")
signal Bar_patasca( barra : float , max_barra : float )

#mensajero para conectar la puntuacion total de puntuacion de pantalla final
@warning_ignore("unused_signal")
signal puntuacion_total(puntos: int)
#puntos de los enemigos
@warning_ignore("unused_signal")
signal puntos(puntos: int)

#mensaje de  inicio de juego 
@warning_ignore("unused_signal")
signal iniciar(activar: bool)
#mensaje de muerte del personaje
@warning_ignore("unused_signal")
signal muerte()
#mensaje de finalizar el mundo
@warning_ignore("unused_signal")
signal finalizar()

#mensaje de finalizar el mundo
@warning_ignore("unused_signal")
signal finalizar_mundo()

#mensaje de reinicio de nivel
@warning_ignore("unused_signal")
signal reinicio_nivel()
#mensaje para enviar el tiempo final
@warning_ignore("unused_signal")
signal tiempo_final(tiempo: String)

#mensajero para conectar el boton de volver del mennu de configuraciones
#esta diseñado porque no esta funcionando el boton por si solo, 
#sinque  necesite entrar al otro lado
@warning_ignore("unused_signal")
signal volver()
