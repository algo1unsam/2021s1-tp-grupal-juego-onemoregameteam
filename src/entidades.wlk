import wollok.game.* //comentario Fer
import equipamento.*
import niveles.*

class Character {

	var vida
	var stamina
	var arma
	var fuerza
	var agilidad
	
	// status list
	// 0 = dead
	// 1 = idle
	// 2 = being attacked
	var property status = 1
	var property imagen
	var property position
	var property nivel

	method image() {
		return imagen
	}

	method atacar(enemigo) {
		if (enemigo.status() == 1 && self.status() != 2) {
			enemigo.recivirDano()
		}
	}

	method defender() {
	}

	method recivirDano() {
		if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)
		} else {
			self.imagen(self.image().replace(".png", "Rojo.png"))
			self.status(2)
			game.schedule(300, { self.imagen(self.image().replace("Rojo.png", ".png"))})
			self.status(1)
			vida -= 20
		}
	}

}

object mainCharacter inherits Character(position = game.at(0, 1), vida = 100) {

	var hechizo
	var oro
	var image = "assets/knight1.png"
	var property enemigo

	override method image() {
		return image
	}

	method equipUpgrade(_level){
		if(_level == 2){
			image = "assets/knight2.png"
		}else{
			image = "assets/knight3.png"
		}
	}
	method descansar() {
	}

	method huir() {
	}

	method magia() {
	}

}

class Enemy inherits Character {

	method visual() {
		game.addVisual(self)
	}

	// el dano de -20 esta para las pruebas
	method estado() {
		//if (self.status() == 0) spawn.generar()
	}

	override method recivirDano() {
		if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)
			
			nivel.spawnManager()
		} else {
			self.imagen(self.image().replace(".png", "Rojo.png"))
			self.status(2)
			game.schedule(300, { self.imagen(self.image().replace("Rojo.png", ".png"))})
			self.status(1)
			vida -= 20
			
			self.atacar(mainCharacter)
		}
	}
}

object spawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]

	method generar() {
		const enemigo1 = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = 0, fuerza = 0, agilidad = 0, imagen = bestias.anyOne(), nivel = null)
		mainCharacter.enemigo(enemigo1)
		enemigo1.visual()
	}

}

object newSpawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]

	method generar(wave, _nivel) {
		const enemigo = new Enemy(position = game.at(18, 1), vida = (50 * wave), stamina = 0, arma = 0, fuerza = 0, agilidad = 0, imagen = bestias.anyOne(), nivel = _nivel)
		mainCharacter.enemigo(enemigo)
		enemigo.visual() 
	}

}

object upgradeBackGround{
	var property image = "assets/nextlvl1.png"
	var property position = game.at(0, 0)
	
	method nextlvl(_nivel){
		if(_nivel == 3){
			image = "assets/nextlvl2.png" 
		}
	}
}

object menuBackground {

	var property image = "assets/menu_background.png"
	var property position = game.at(0, 0)

}

class MenuOpt {

	var property image
	var property position
	var property selected = mainMenu.selected() == self

}

object start inherits MenuOpt {

	override method image() {
		if (mainMenu.selected() == self) {
			return "assets/start_selected.png"
		} else return "assets/start.png"
	}

	override method position() = game.at(24, 7)

	method action() {
		nivel1.iniciar()
	}

}

object quit inherits MenuOpt {

	override method image() {
		if (mainMenu.selected() == self) {
			return "assets/quit_selected.png"
		} else return "assets/quit.png"
	}

	override method position() = game.at(24, 6)

	method action() {
		game.stop()
	}

}

