import wollok.game.*
import utilidades.*

class Interactivo{
	var property position
	method mover( direccion ){
		if ( (direccion == sentido.derecha()) && (position.x() < game.width() - 1) ) {
			position = position.right(1)
		
		} else if ( (direccion == sentido.izquierda()) && (position.x() > 0) ) {
			position = position.left(1)
			
		} else if ( (direccion == sentido.arriba()) && (position.y() < game.height() - 1) ) {
			position = position.up(1)
			
		} else if( (direccion == sentido.abajo()) && (position.y() > 0) ) {
			position = position.down(1)
			
		}
	}
}

class Caja inherits Interactivo{
	const property image = "Caja.png"
	method estaEnElDeposito( deposito ){
		return
			(position.x() > deposito.limiteInferior().x()) && 
			(position.x() < deposito.limiteSuperior().x()) && 
			(position.y() > deposito.limiteInferior().y()) && 
			(position.y() < deposito.limiteSuperior().y()
		)
	}
}

class Personaje inherits Interactivo{
	const property image = "player.png"
	var orientacionDeMovimiento
	method orientacionDeMovimiento(){	return orientacionDeMovimiento }
	override method mover(direccion){
		super( direccion )
		orientacionDeMovimiento = direccion
	}
}

class Deposito{
	var property limiteInferior = new Position(x = 5 , y = 10)
	var property limiteSuperior = new Position(x = 9 , y = 15)
}


