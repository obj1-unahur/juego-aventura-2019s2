import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*

//-------------------------------------------------------------------------//

class Nivel{
	var personaje = new Personaje()
	var elementosVisuales = []
	var puertaDeEscape
	method preparar(){
		personaje.position(new Position(x = 8, y=10))
		game.addVisual( new Fondo( image = "fondoCompleto.png" ) )
		game.addVisual( personaje )
		
		keyboard.left().onPressDo({ personaje.mover(sentido.izquierda() ) })
		keyboard.right().onPressDo({ personaje.mover(sentido.derecha() ) })
		keyboard.up().onPressDo({ personaje.mover(sentido.arriba() ) })
		keyboard.down().onPressDo({ personaje.mover( sentido.abajo()) })
	}
	method pasarDeNivel()
}

//-------------------------------------------------------------------------//

object nivelBloques inherits Nivel{
	const deposito = new Deposito( limiteInferior = game.at(5,10), limiteSuperior = game.at(9,15))
	
	override method preparar() {
		super()
		self.agregarCajas(5)
		elementosVisuales.forEach{ caja => 
			game.addVisual( caja )
			game.onCollideDo( caja, { 
				caja.efectoDeCoalision()
				if( caja.estaEnElDeposito( deposito )){
					game.removeVisual( caja )
					elementosVisuales.remove( caja )
				}
				if(elementosVisuales.isEmpty()){
					game.addVisual( puertaDeEscape = new Puerta( position = utilidadesParaJuego.posicionRandom()) )
					game.onCollideDo( puertaDeEscape , { puertaDeEscape.efectoDeCoalision(self) } )		
				}
			})
		}		
	}
	method agregarCajas( cantidad ){
		if(cantidad > 0){
			elementosVisuales.add( new Caja( position = utilidadesParaJuego.posicionRandom()))
			self.agregarCajas(cantidad-1)
		}
	}
	override method pasarDeNivel() {
		game.clear()
		game.addVisual( new Fondo( image = "fondoCompleto.png" ) )
		game.schedule(2500, {
			game.clear()
			game.addVisual(new Fondo( image = "finNivel1.png" ) )
			game.schedule( 3000, {
				game.clear()
				nivelLlaves.preparar()
			})
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
			game.onCollideDo( elemento, {
				game.removeVisual( elemento )
				elementosVisuales.remove( elemento )
				elemento.efectoDeColision( personaje )
				if( personaje.llavesRecogidas() == 3) {
					game.addVisual( puertaDeEscape = new Puerta( position = utilidadesParaJuego.posicionRandom()) )
					game.onCollideDo( puertaDeEscape , { puertaDeEscape.efectoDeCoalision(self) } )	7
				}
			})
		}
		if( personaje.tieneHambre() ){
			game.say( personaje, "tengo poca vida, necesito comer!!!" )
		}
		if( personaje.vida() == 0){
			self.perder()
		}
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
	
	method perder(){
		game.clear()
		game.addVisual( new Fondo( image = "perdiste.jpg") )
		game.schedule(2500, { nivelBloques.pasarDeNivel() } )
	}
	
	override method pasarDeNivel() {
		game.clear()
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		game.schedule(2500, {
			game.clear()
			game.addVisual(new Fondo(image="ganamos.png"))
			game.schedule(3000, {
				game.stop()
			})
		})
	}	
}
