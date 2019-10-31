import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*

//-------------------------------------------------------------------------//

class Nivel{
	var personaje = new Personaje()
	var elementosVisuales = []
	var puertaDeEscape = new Puerta( position = utilidadesParaJuego.posicionRandom())
	var nivelAnterior = self
	var nivelSiguiente = self
	method preparar(){
		personaje.position(new Position(x = 8, y=10))
		game.addVisual( new Fondo( image = "fondoCompleto.png" ) )
		personaje.show()
		game.addVisual( personaje )
		
		keyboard.left().onPressDo({ personaje.mover(sentido.izquierda() ) })
		keyboard.right().onPressDo({ personaje.mover(sentido.derecha() ) })
		keyboard.up().onPressDo({ personaje.mover(sentido.arriba() ) })
		keyboard.down().onPressDo({ personaje.mover( sentido.abajo()) })
		
		if( personaje.tieneHambre() ){
			game.say( personaje, "tengo poca vida, necesito comer!!!" )
		}
		if( personaje.vida() == 0){
			self.perder()
		}
	}
	method perder(){
		game.clear()
		game.addVisual( new Fondo( image = "perdiste.jpg") )
		game.schedule(2500, { nivelAnterior.pasarDeNivel() } )
	}
	method pasarDeNivel(){
		nivelSiguiente.nivelAnterior(self)
		game.clear()
		game.addVisual(new Fondo( image="fondoCompleto.png" ))
		game.schedule(2500, { game.clear() } )
	}
	method nivelCompleto(){
		puertaDeEscape.show()
		game.addVisual( puertaDeEscape )
		game.onCollideDo( puertaDeEscape , { unPrsonaje => 
			if(puertaDeEscape.position() == personaje.position()){
				puertaDeEscape.efectoDeCoalision(self)
			}
		})
	}
}

//-------------------------------------------------------------------------//

object nivelBloques inherits Nivel{
	const deposito = new Deposito( limiteInferior = game.at(5,10), limiteSuperior = game.at(9,15))
	var cantidadDeCajas = 5
	override method preparar() {
		super()
		nivelSiguiente = nivelLlaves
		self.agregarCajas( cantidadDeCajas )
		elementosVisuales.forEach{ caja => 
			game.addVisual( caja )
			game.onCollideDo( caja, { unPersonje =>	caja.efectoDeCoalision( personaje )	})
			game.onTick(20,"al Deposito" ,{
				if( caja.estaEnElDeposito( deposito ) ){
					caja.hide()
					deposito.agregar( caja )
				}
			})
		}
		game.onTick(20, "mostrarPuerta",{
			if( deposito.cantidad() == 5 ){
				self.nivelCompleto()
				game.removeTickEvent( "mostrarPuerta" )
			}
		})
	}
	method agregarCajas( cantidad ){
		if(cantidad > 0){
			elementosVisuales.add( new Caja( position = utilidadesParaJuego.posicionRandom()))
			elementosVisuales.last().show()
			self.agregarCajas(cantidad-1)
		}
	}
	override method pasarDeNivel() {
		super()
		game.addVisual(new Fondo( image = "finNivel1.png" ) )
		game.schedule( 3000, {
				game.clear()
				nivelSiguiente.preparar()
		})
	}
		
}

//-------------------------------------------------------------------------//

object nivelLlaves inherits Nivel{
	override method preparar(){
		super()
		self.agregarLlaves(3)
		self.agregarPollos(3)
		elementosVisuales.forEach{ 
			elemento => game.addVisual( elemento) 
			game.onCollideDo( elemento, { unPersonje =>
				if(elemento.position() == personaje.position()){
					elemento.efectoDeColision( personaje )
					game.removeVisual( elemento )
					elementosVisuales.remove( elemento )
				}
			})
		}
		game.onTick(10,"Has Recogido Todas Las Llaves",{
				if( personaje.llavesRecogidas() == 3) {
					game.addVisual( puertaDeEscape = new Puerta( position = utilidadesParaJuego.posicionRandom()) )
					self.nivelCompleto()
				}
		})
	}
	
	method agregarLlaves( cantidad ){
		if(cantidad > 0){
			elementosVisuales.add( new Llave( position = utilidadesParaJuego.posicionRandom()))
			self.agregarLlaves(cantidad-1)
		}
	}
	
	method agregarPollos( cantidad ){
		if(cantidad > 0){
			elementosVisuales.add( new Pollo( position = utilidadesParaJuego.posicionRandom()))
			self.agregarPollos(cantidad-1)
		}
	}
	
	override method pasarDeNivel() {
		super()
		game.addVisual(new Fondo(image="ganamos.png"))
		game.schedule(3000, { game.stop() } )
	}	
}
