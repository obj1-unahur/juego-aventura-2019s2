import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*

class Nivel{
	var personaje = new Personaje()
	const deposito = new Deposito( limiteInferior = game.at(5,10), limiteSuperior = game.at(9,15))
	method preparar(){
		personaje.position(new Position(x = 8, y=10))
		game.addVisual( new Fondo( image = "fondoCompleto.png" ) )
		game.addVisual( personaje )
		
		keyboard.left().onPressDo({ personaje.mover(sentido.izquierda())})
		keyboard.right().onPressDo({ personaje.mover(sentido.derecha())})
		keyboard.up().onPressDo({ personaje.mover(sentido.arriba())})
		keyboard.down().onPressDo({ personaje.mover( sentido.abajo()) })
		keyboard.enter().onPressDo({ if(self.nivelCompletado()){
			self.pasarDeNivel()
		}})
	}
	method nivelCompletado()
	method pasarDeNivel()
}


object nivelBloques inherits Nivel{
	const property listaDeCajas = []
	var posicionSalida = game.at(0,0)
	override method preparar() {
		super()
		self.agregarCajas(5)
		listaDeCajas.forEach{ caja => game.addVisual( caja ) }
	}
	
	method agregarCajas( cantidad ){
		if(cantidad > 0){
			listaDeCajas.add( new Caja( position = utilidadesParaJuego.posicionRandom()))
			self.agregarCajas(cantidad-1)
		}
	}

	override method nivelCompletado(){
		return ((personaje.position() == posicionSalida) && ( listaDeCajas.all{ caja => caja.estaEnElDeposito( deposito ) }))
	}
	
	override method pasarDeNivel() {
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual( new Fondo( image = "fondoCompleto.png" ) )
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo( image = "finNivel1.png" ) )
			// después de un ratito ...
			game.schedule( 3000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelLlaves.preparar()
			})
		})
	}
		
}

object nivelLlaves inherits Nivel{
	override method nivelCompletado(){
		return true
	}
	override method pasarDeNivel() {
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="ganamos.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// fin del juego
				game.stop()
			})
		})
	}
	
	
