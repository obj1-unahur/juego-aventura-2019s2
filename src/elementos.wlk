import wollok.game.*
import utilidades.*

//-------------------------------------------------------------------------//

class ObjetoVisual{
	// estructura para crear un objeto visual, es decir, un objeto que se va a mostrar en el tablero
	// inicialmente transparente, cada objeto derivado debe definir su propia apariencia (image)
	var property image = "Empty.png"
	var property position
	method efectoDeCoalision( personaje ){}
	method hide(){
		image = "Empty.png"
	}
	method show()
}

//-------------------------------------------------------------------------//

class ObjetoMovil inherits ObjetoVisual{
	// representa un objeto que se puede mover entre los casilleros del tablero
	var orientacionDeMovimiento = sentido.izquierda()
	
	method mover( direccion ){
		if ( (direccion == sentido.derecha()) && (position.x() < game.width() - 1) ) {
			position = position.right(1)
		
		} else if ( (direccion == sentido.izquierda()) && (position.x() > 0) ) {
			position = position.left(1)
			
		} else if ( (direccion == sentido.arriba()) && (position.y() < game.height() - 1) ) {
			position = position.up(1)
			
		} else if( (direccion == sentido.abajo()) && (position.y() > 0) ) {
			position = position.down(1)
			
		} else {
			// Si no se pudo mover en el sentido dado es porque el objeto esta en el borde
			// Entonces con el fin de que el objeto no se quede clavado en un borde
			// simulo un "efecto rebote" moviendolo en la direccion contraria
			self.mover( sentido.inverso(direccion))
		}
		orientacionDeMovimiento = direccion
	}
}

//-------------------------------------------------------------------------//

class Personaje inherits ObjetoMovil{
	var property vida = 10
	var property llavesRecogidas = 0
	
	method recogerLlave(){
		llavesRecogidas += 1
	}
	method orientacionDeMovimiento(){	
		return orientacionDeMovimiento
	}
	method comer( unAlimento ){
		vida += unAlimento.energia()
	}
	method tieneHambre(){
		return ( vida < 10 )
	}
	override method mover(direccion){
		super( direccion )
		vida -= 1
	}	
	override method show(){ 
		image = "Player.png"
	}
}

//-------------------------------------------------------------------------//

class Caja inherits ObjetoMovil{
	var property estaDepositada = false
	method estaEnElDeposito( deposito ){
		return
			(position.x() > deposito.limiteInferior().x()) && 
			(position.x() < deposito.limiteSuperior().x()) && 
			(position.y() > deposito.limiteInferior().y()) && 
			(position.y() < deposito.limiteSuperior().y()
		)
	}
	
	override method efectoDeCoalision( unPersonaje ){
		self.mover(unPersonaje.orientacionDeMovimiento())
	}	
	override method show(){ 
		image = "Caja.png"
	}
}

//-------------------------------------------------------------------------//

class Llave inherits ObjetoVisual{
	var fueRecogida = false
	override method show(){ 
		image = "Llave.png"
	}
	override method efectoDeCoalision( unPersonaje ){
		if(not fueRecogida){
			unPersonaje.recogerLlave()
			fueRecogida = true
		}
	}
}

//-------------------------------------------------------------------------//

class Pollo inherits ObjetoVisual{
	var property energia = 10
	override method show(){ 
		image = "Pollo.png"
	}
	override method efectoDeCoalision( unPersonaje ){
		unPersonaje.comer( self )
		energia = 0
	}
}

//-------------------------------------------------------------------------//

class Puerta inherits ObjetoVisual{
	var estaEscondida = true
	override method efectoDeCoalision( unNivel ){
		unNivel.pasarDeNivel()
	}
	override method show(){
		if( estaEscondida ){
			estaEscondida = false
			image = "Puerta.png"
		}
	}	
}

//-------------------------------------------------------------------------//

class Deposito{
	var property cantidad = 0
	var property limiteInferior = new Position(x = 4 , y = 8)
	var property limiteSuperior = new Position(x = 8 , y = 12)
	method agregar( unaCaja ){
		if(not unaCaja.estaDepositada()){
			cantidad += 1
			unaCaja.estaDepositada( true )
		}
	}
}
	
