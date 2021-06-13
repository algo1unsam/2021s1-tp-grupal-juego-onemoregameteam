import wollok.game.*
import equipamento.*
import niveles.*
import movimiento.*
import barravida.*

class Character {

	var vida
	var stamina = 3
	var agilidad		//numero entre 0 y 100, representa porcentaje
	var arma
	var property armadura
	var barName
	
	// status list
	// 0 = dead
	// 1 = idle
	// 2 = being attacked
	var property status = 1
	var property defiende = false
	var property imagen
	var property position
	var property nivel

	method image() {
		return imagen
	}
	
	method stamina() = stamina
	method vida() = vida
	method danioBase() = 5
	
	method defensaBase() = 5

	method atacar(enemigo) {
		if (enemigo.status() == 1 && self.status() != 2) {
			enemigo.recibirDano(self.danioBase()+arma.danio())
		} 
	}

	method defender(){}

	method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		if (defiende) { danioRecibido/= 2 }		 														///
		game.schedule(900,{cambioImagen.roja(self)})
		self.status(2)
		game.schedule(1500,{cambioImagen.normal(self)})
		self.status(1)
		if (not (0.randomUpTo(100).between(0,agilidad))) vida -= new Range(start = danioRecibido-5, end = danioRecibido).anyOne()	//> Daño entre -5 ataque recibido y ataque recibido		
		if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)
		}
	}
	

}

object mainCharacter inherits Character(position = game.at(0, 1), vida = 50, agilidad = 5, arma = new Arma(danio=5, nombre='?'), armadura = new Armadura(reduccionDanio=5, nombre='?'), imagen="assets/knight1.png",barName = barraVidaProta) {

	var property enemigo
	
	override method danioBase() = 45

	method equipUpgrade(_level){
		arma.danio(arma.danio()+arma.danio()*2/3)											//\ Aumenta ataque y defensa
		armadura.reduccionDanio(armadura.reduccionDanio()+armadura.reduccionDanio()*2/3)	/// en 2/3
		if(_level == 2){
			//image = "assets/knight2.png"
			self.imagen("assets/knight2.png")
			
		}else{
			//image = "assets/knight3.png"
			self.imagen("assets/knight3.png")
			
		}
	}
	
	override method atacar(enemigo1) {
		if (enemigo1.status() == 1 && self.status() != 2) {
			accionConjDer.accion()
			enemigo1.recibirDano(self.danioBase()+arma.danio()-enemigo1.armadura().reduccionDanio())
			position = game.at(0, 1)
			
		} 
	}
	
	override method defender() {		
		self.defiende(true)
		enemigo.atacar(self)
		self.defiende(false)
	
	}
	
	override method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		if (defiende) { danioRecibido/= 2 }		 														///
		game.schedule(900,{self.imagen(self.image().replace(".png", "Rojo.png"))})
		self.status(2)
		game.schedule(1500,{self.imagen(self.image().replace("Rojo.png", ".png"))})
		self.status(1)
		if (not (0.randomUpTo(100).between(0,agilidad))) vida -= new Range(start = danioRecibido-5, end = danioRecibido).anyOne()	//> Daño entre -5 ataque recibido y ataque recibido
		if (vida <= 0) {
			game.removeVisual(self)
			self.status(0)
			game.schedule(1500, {gameEnd.iniciar()})
		}
	}
	
	method curar() {
		if(stamina > 0 and vida < 35){
			stamina-=1
			vida += 15
		}
	}
	
	//Metodo que se utiliza al temrinar cada etapa. Subi la stamina(pociones) en 1
	method staminaUp(){
		stamina += 1
	}

}

class Enemy inherits Character {
	

var property enemigo = mainCharacter

	method visual() {
		game.addVisual(self)
	}

	override method recibirDano(danio) {
		var danioRecibido = danio																		//\  Guarda daño en variable local 
																										// | Si esta defendiendo reduce daño a la mitad
		if (defiende) { danioRecibido/= 2 }		 														///
		game.schedule(900,{cambioImagen.roja(self)})	
		self.status(2)
		game.schedule(1500,{cambioImagen.normal(self)})
		self.status(1)
		if (not (0.randomUpTo(100).between(0,agilidad))) vida -= new Range(start = danioRecibido-5, end = danioRecibido).anyOne()	//> Daño entre -5 ataque recibido y ataque recibido
		if (vida <= 0) {
			game.schedule(1000, { game.removeVisual(barraVidaE1)})
			game.schedule(1000,{game.removeVisual(self)})
			self.status(0)
			game.schedule(2000,{nivel.spawnManager()})	
			if (nivel.cont() > 0) game.schedule(2000, { game.addVisual(barraVidaE1) })		
			
		} else{
			game.schedule(2200,{self.atacar(mainCharacter)})		
			
		}
	}
	
	override method atacar(enemigo1) {
		if (enemigo1.status() == 1 && self.status() != 2) {
			accionConjizq.accion()
			enemigo1.recibirDano(self.danioBase()+arma.danio()-enemigo1.armadura().reduccionDanio())
			position = game.at(18, 1)
	} 
}

}


object cambioImagen{
	
	method roja(personaje){ personaje.imagen(personaje.image().replace(".png", "Rojo.png")) }
	
	method normal(personaje){ personaje.imagen(personaje.image().replace("Rojo.png", ".png"))}
}

object spawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]

	method generar() {
		const enemigo1 = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = new Arma(danio=5, nombre='?'), armadura = new Armadura(reduccionDanio=5, nombre='?'), agilidad = 5, imagen = bestias.anyOne(), nivel = null,barName = barraVidaE1)
		mainCharacter.enemigo(enemigo1)
		enemigo1.visual()
	}

}

object newSpawn {

	const bestias = [ "assets/goblin.png", "assets/skeleton.png", "assets/demon.png" ]

	method generar(wave, _nivel, numNivel) {
		const enemigo = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = new Arma(danio=(5*numNivel) + wave, nombre='?'), armadura = new Armadura(reduccionDanio=(5*numNivel) + wave, nombre='?'), agilidad = 5, imagen = bestias.anyOne(), nivel = _nivel,barName = barraVidaE1)
		mainCharacter.enemigo(enemigo)
		//cambia entidad enemigo a mover
		accionConjizq.charact(enemigo)
		barraVidaE1.persona(enemigo)
		enemigo.visual() 
	}

}

object bossSpawn{
	method generar(wave, _nivel, numNivel) {
		const enemigo = new Enemy(position = game.at(18, 1), vida = 50, stamina = 0, arma = new Arma(danio=16, nombre='?'), armadura = new Armadura(reduccionDanio=50, nombre='?'), agilidad = 15, imagen = "assets/boss.png", nivel = _nivel,barName = barraVidaE1)
		mainCharacter.enemigo(enemigo)
		//cambia entidad enemigo a mover
		accionConjizq.charact(enemigo)
		barraVidaE1.persona(enemigo)
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

