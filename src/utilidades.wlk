import wollok.game.*

object utilidadesParaJuego {
	// objeto que se utiliza para obtener un numero aleatorio
	method posicionRandom() {
		return game.at(
			0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height()).truncate(0)
		)
	}
}

object sentido{
	// Un objeto util para obtener una direccion o su opuesto
	method arriba(){ return "arriba" }
	method abajo(){ return "abajo" }
	method izquierda(){ return "izquierda" }
	method derecha(){ return "derecha" }
	
	method inverso( unSentido ){
		if( unSentido == "arriba" ){
			return self.abajo()
		} else if( unSentido == "abajo" ){
			return self.arriba()
		} else if(  unSentido == "derecha" ){
			return self.izquierda()
		} else if( unSentido == "izquierda"){
			return self.derecha()
		} else { return unSentido }
	}
}
