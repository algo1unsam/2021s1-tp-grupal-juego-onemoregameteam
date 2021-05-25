import entidades.*
import wollok.game.*
import equipamento.*
import mainMenu.*

class nivel {
	method iniciar() {
		game.clear()
		game.addVisual(mainCharacter)
		self.spawnManager()
		config.nivel1()
	}
	
	
}

object nivel1 inherits nivel{
	const waveLenght = 4
	var cont = waveLenght
	
	method spawnManager(){
		if(cont > 0){
			newSpawn.generar(1, self)
			cont -= 1
		} 
	}
}

object nivel2 inherits nivel{
	const waveLenght = 5
	var cont = waveLenght
	
	method spawnManager(){
		if(cont > 0){
			newSpawn.generar(1, self)
			cont -= 1
		} 
	}
}

object pantallaUpgrade {
	method iniciar() {
		game.clear()
		game.addVisual("EL FONDO PARA ESTA COSA")
		game.addVisual("CARTEL DEL LOOT")
		//Y ASI CON BOTON PARA CONTINUAR Y BOTON PARA MENU PRINCIPAL
	}
}
object mainMenu {

	var property selected
	var backgroundMusic = game.sound("sounds/introOST.mp3")

	method iniciar() {
		game.clear()

		game.addVisual(menuBackground)
		game.addVisual(start)
		game.addVisual(quit)
		self.introMusic()
		config.mainMenu()
	}

	method down() {
		if (quit.selected()) {
			self.selected(start)
		} else self.selected(quit)
	}

	method up() {
		if (start.selected()) {
			self.selected(quit)
		} else self.selected(start)
	}

	method action() {
		selected.action()
	}

	method introMusic() {
		game.schedule(100, { backgroundMusic.play()})
	}

}

object config {

	method mainMenu() {
		keyboard.up().onPressDo({ mainMenu.up()})
		keyboard.down().onPressDo({ mainMenu.down()})
		keyboard.enter().onPressDo({ mainMenu.action()})
	}

	method nivel1() {
		keyboard.a().onPressDo({ mainCharacter.atacar(mainCharacter.enemigo())})
		keyboard.n().onPressDo({ mainCharacter.enemigo().estado()})
	}

}

