import wollok.game.* //comentario Fer
import equipamento.*
import niveles.*

class Character {
	var vida
	var stamina
	var arma
	var fuerza
	var agilidad
		
	var property imagen
	var property position
	
	method image() {
		return imagen
	}
	
	method atacar(enemigo) {
		
	}
	
	method defender(){
		
	}
	
	
}

object mainCharacter inherits Character {
	
	var hechizo
	var oro
	
	method descansar() {
		
	}
	
	method huir() {
		
	}
	
	method magia() {
		
	}
}

