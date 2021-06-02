import wollok.game.* //comentario Fer
import niveles.*

class Arma {
	var property danio
	var property nombre
}

class Armadura {
	var property reduccionDanio
	var property nombre
}

class LibroHechizo {
	var property danio
	var property defensa
	var property curacion
	var property nombre
}

object dictEquipo {
	const dictArmas = new Dictionary()
	const dictArmaduras = new Dictionary()
	const dictHechizos = new Dictionary()
	
	method init() {
		dictArmas.put("Daga",0,5)
	}
}
