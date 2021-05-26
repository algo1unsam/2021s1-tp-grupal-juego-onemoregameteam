import wollok.game.*
import equipamento.*
import niveles.*

class Character {

	var vida
	var stamina
	var agilidad
	var arma
	var armadura
	
	// status list
	// 0 = dead
	// 1 = idle
	// 2 = being attacked
	var property status = 1
	var defiende = false
	var property imagen
	var property position
	var property nivel

	method image() {
		return imagen
	}
	
	method danioBase() = 5
	method defensaBase() = 5

	method atacar(enemigo) {
		if (enemigo.status() == 1 && self.status() != 2) {
			enemigo.recibirDano(self.danioBase()+arma.danio())
		} 
	}

	method defender() { defiende = true }

	method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		if (defiende) { danioRecibido/= 2 }		 														///
		self.imagen(self.image().replace(".png", "Rojo.png"))
		self.status(2)
		game.schedule(300, { self.imagen(self.image().replace("Rojo.png", ".png"))})
		self.status(1)
		vida -= new Range(start = danioRecibido-5, end = danioRecibido).anyOne()						//> Daño entre -5 ataque recibido y ataque recibido
		if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)
		}
	}

}

object mainCharacter inherits Character(position = game.at(0, 1), vida = 100, arma = new Arma(danio=5, nombre='?'), armadura = new Armadura(reduccionDanio=5, nombre='?')) {

	var hechizo
	var oro
	var image = "assets/knight1.png"
	var property enemigo

	override method image() {
		return image
	}
	
	override method danioBase() = 10

	method equipUpgrade(_level){
		arma.danio(arma.danio()+arma.danio()*2/3)											//\ Aumenta ataque y defensa
		armadura.reduccionDanio(armadura.reduccionDanio()+armadura.reduccionDanio()*2/3)	/// en 2/3
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

	override method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		if (defiende) { danioRecibido/= 2 }		 														///
		self.imagen(self.image().replace(".png", "Rojo.png"))
		self.status(2)
		game.schedule(300, { self.imagen(self.image().replace("Rojo.png", ".png"))})
		self.status(1)
		vida -= new Range(start = danioRecibido-5, end = danioRecibido).anyOne()						//> Daño entre -5 ataque recibido y ataque recibido
		if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)			
			nivel.spawnManager()
		} else {self.atacar(mainCharacter)}		
	}
}

object spawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]

	method generar() {
		const enemigo1 = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = new Arma(danio=5, nombre='?'), armadura = new Armadura(reduccionDanio=5, nombre='?'), agilidad = 0, imagen = bestias.anyOne(), nivel = null)
		mainCharacter.enemigo(enemigo1)
		enemigo1.visual()
	}

}

object newSpawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]

	method generar(wave, _nivel, numNivel) {
		const enemigo = new Enemy(position = game.at(18, 1), vida = (50 * wave), stamina = 0, arma = new Arma(danio=(5*numNivel) + wave, nombre='?'), armadura = new Armadura(reduccionDanio=(5*numNivel) + wave, nombre='?'), agilidad = 0, imagen = bestias.anyOne(), nivel = _nivel)
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

