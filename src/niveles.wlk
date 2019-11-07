import wollok.game.*
import fondo.*
import elementos.*
import utilidades.*

//-------------------------------------------------------------------------//

class Nivel{
	var personaje = new Personaje()
	var elementosVisuales = []
	var puertaDeEscape = new Puerta( position = utilidadesParaJuego.posicionRandom())
	var property nivelAnterior = self
	var property nivelSiguiente = self
	
	method preparar(){
		// Prepara los valores iniciales de un nivel
		personaje.position(new Position(x = 8, y=10))
		game.addVisual( new Fondo( image = "fondoCompleto.png" ) )
		personaje.show()
		game.addVisual( personaje )
		
		// Configuracion de teclas para mover al jugador
		keyboard.left().onPressDo({ personaje.mover(sentido.izquierda() ) })
		keyboard.right().onPressDo({ personaje.mover(sentido.derecha() ) })
		keyboard.up().onPressDo({ personaje.mover(sentido.arriba() ) })
		keyboard.down().onPressDo({ personaje.mover( sentido.abajo()) })
	}
	method perder(){
		// Añade un fondo que indica que perdimos y resetea el nivel
		game.clear()
		game.addVisual( new Fondo( image = "perdiste.jpg") )
		game.schedule(2000, { self.reset() } )
	}
	method reset(){
		// Prepara nuevamente los valores iniciales de un nivel
		game.clear()
		personaje = new Personaje()
		elementosVisuales = []
		puertaDeEscape = new Puerta( position = utilidadesParaJuego.posicionRandom())
		self.preparar()
	}
	method misionCompleta(){
		// Muestra la puerta de escape en el tablero cuando se cumpla la mision del nivel
		game.addVisual( puertaDeEscape )
		puertaDeEscape.show()
		game.onCollideDo( puertaDeEscape , { unPrsonaje => 
			if(puertaDeEscape.position() == personaje.position()){
				puertaDeEscape.efectoDeCoalision(self)
			}
		})
	}
	method pasarDeNivel(){
		// Avanza al siguiente nivel
		nivelSiguiente.nivelAnterior(self)
		game.clear()
	}
}

//-------------------------------------------------------------------------//

object nivelBloques inherits Nivel{
	const deposito = new Deposito( limiteInferior = game.at(4,6), limiteSuperior = game.at(10,13))
	override method preparar() {
		super()
		nivelSiguiente = nivelLlaves
		self.agregarCajas( 5 )
		elementosVisuales.forEach{ caja => 
			game.addVisual( caja )
			game.onCollideDo( caja, { unPersonje =>	caja.efectoDeCoalision( personaje )	})
			
			game.onTick(20,"alDeposito" ,{
				if( caja.estaEnElDeposito( deposito ) ){
					// Agrega una caja al deposito si esta en esa zona
					caja.hide()
					deposito.agregar( caja )
					game.say( personaje, "Caja llevada al deposito")
				}
			})
		}
		game.onTick(20, "mostrarPuerta",{
			if( deposito.cantidad() == 5 ){
				// Muestra la puerta de escape si el deposito contiene 5 cajas
				self.misionCompleta()
				game.removeTickEvent( "mostrarPuerta" )
			}
		})
	}
	method agregarCajas( cantidad ){
		// Agrega la cantidad de cajas indicadas al tablero (5 para este ejemplo). Se utiliza recursividad al no disponer de while o for
		if(cantidad > 0){
			elementosVisuales.add( new Caja( position = utilidadesParaJuego.posicionRandom()))
			elementosVisuales.last().show()
			self.agregarCajas(cantidad-1)
		}
	}
	override method pasarDeNivel() {
		super()
		game.clear()
		game.addVisual( new Fondo( image = "finNivel1.png" ) )
		game.schedule(2000, { nivelSiguiente.preparar() } )
	}
		
}

//-------------------------------------------------------------------------//

object nivelLlaves inherits Nivel{
	override method preparar(){
		super()
		self.agregarLlaves(3)
		self.agregarPollos(1)
		elementosVisuales.forEach{ 
			elemento => game.addVisual( elemento) 
			game.onCollideDo( elemento, { unPersonje =>
				if(elemento.position() == personaje.position()){
					// La condicion especifica que se colisione con el jugador ya que puede haber un pollo y una llave en el mismo casillero por ejemplo
					// pero el o los elementos solo deben reaccionar cuando pase el jugador por ese lugar 
					elemento.efectoDeCoalision( personaje )
				}
			})
		}
		game.onTick( 20, "enPeligro",{
			if( personaje.tieneHambre() ){
				game.say( personaje, "tengo poca vida, necesito comer!!!" )
			}
			if( personaje.vida() <= 0){
				self.perder()
			}
		})
		game.onTick(10,"llavesRecogidas",{
				if( personaje.llavesRecogidas() == 3) {
					// Muestra la puerta de escape cuando el jugador recoga las 3 llaves del tablero
					self.misionCompleta()
					game.removeTickEvent( "llavesRecogidas" )
				}
		})
	}
	
	method agregarLlaves( cantidad ){
		// Agrega la cantidad indicada de llaves al tablero (3 para este ejemplo). Se utiliza recursividad al no disponer de while o for
		if(cantidad > 0){
			elementosVisuales.add( new Llave( position = utilidadesParaJuego.posicionRandom()))
			elementosVisuales.last().show()
			self.agregarLlaves(cantidad-1)
		}
	}
	
	method agregarPollos( cantidad ){
		// Agrega la cantidad indicada de pollos al tablero (3 para este ejemplo). Se utiliza recursividad al no disponer de while o for
		if(cantidad > 0){
			elementosVisuales.add( new Pollo( position = utilidadesParaJuego.posicionRandom()))
			elementosVisuales.last().show()
			self.agregarPollos(cantidad-1)
		}
	}
	
	override method pasarDeNivel() {
		super()
		game.addVisual(new Fondo(image="ganamos.png"))
		game.schedule(3000, { game.stop() } )
	}	
}
