import wollok.game.*
import utilidades.*

//-------------------------------------------------------------------------//

class ObjetoVisual{
	var property position
	method efectoDeCoalision( personaje ){}
	method colisiones(){
		return game.colliders(self)
	}
}

//-------------------------------------------------------------------------//

class ObjetoMovil inherits ObjetoVisual{
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
	const property image = "player.png"
	var property vida = 100
	var property llavesRecogidas = 0
	
	method recoogerLlave(){
		llavesRecogidas += 1
	}
	method orientacionDeMovimiento(){	
		return orientacionDeMovimiento
	}
	method comer(){
		vida += 10
	}
	method tieneHambre(){
		return ( vida < 10 )
	}
	override method mover(direccion){
		super( direccion )
		vida -= 1
	}
}

//-------------------------------------------------------------------------//

class Caja inherits ObjetoMovil{
	const property image = "Caja.png"
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
}

//-------------------------------------------------------------------------//

class Llave inherits ObjetoVisual{
	const property image = "Llave.png"
	override method efectoDeCoalision( unPersonaje ){
		unPersonaje.recogerLlave()
	}
}

//-------------------------------------------------------------------------//

class Pollo inherits ObjetoVisual{
	const property image = "pollo.png"
	override method efectoDeCoalision( unPersonaje ){
		unPersonaje.comer()
	}
}

//-------------------------------------------------------------------------//

class Puerta inherits ObjetoVisual{
	const property image = "puerta.png"
	override method efectoDeCoalision( unNivel ){
		unNivel.pasarDeNivel()
	}
	
}

//-------------------------------------------------------------------------//

class Deposito{
	var property limiteInferior = new Position(x = 5 , y = 10)
	var property limiteSuperior = new Position(x = 9 , y = 15)
}
