import wollok.game.*

object utilidadesParaJuego {
	method posicionArbitraria() {
		return game.at(
			0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height()).truncate(0)
		)
	}
}

object sentido{
	method arriba(){ return "arriba" }
	method abajo(){ return "abajo" }
	method izquierda(){ return "izquierda" }
	method derecha(){ return "derecha" }
}
