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
	
	method atacar(enemigo){
		enemigo.recivirDano()
	}
	
	method defender(){
		
	}
	
	
}

object mainCharacter inherits Character(position =  game.at(0,1), vida = 100) {
	
	var hechizo
	var oro
	var property enemigo
	
	override method image(){
		return "assets/knight2.png"
	}
	
	method descansar() {
		
	}
	
	method huir() {
		
	}
	
	method magia() {
		
	}
}

class Enemy inherits Character{
	
	method visual(){
		game.addVisual(self)
	}
	
	//el dano de -20 esta para las pruebas
	method recivirDano(){	
		if(vida <= 0) game.removeVisual(self) 
		else { 	
		 	const a = self.imagen()
		 	self.imagen(self.cambio(self.imagen()))
		 	game.schedule(1000,  {self.imagen(a)})
		 	vida -= 20	}
	}
	method cambio(imag){
		if(imag == "assets/skeleton.png") return "assets/skeletonRojo.png"
		else if(imag == "assets/demon.png") return "assets/demonRojo.png"
		else return "assets/goblinRojo.png"
	}
	
	method estado(){
		if(vida < 0) spawn.generar()
	}
	
}



object spawn{
	const bestias = ["assets/goblin.gif", "assets/skeleton.png", "assets/demon.png"]
	method generar(){
		const enemigo1 = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = 0, fuerza = 0, agilidad = 0, imagen = bestias.anyOne())
		mainCharacter.enemigo(enemigo1)
		enemigo1.visual()
	}
}
