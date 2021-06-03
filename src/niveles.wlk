import entidades.*
import wollok.game.*
import equipamento.*
import mainMenu.*

class Nivel {
	
	method iniciar() {
		game.clear()
		game.addVisual(mainCharacter)
		self.spawnManager()
		config.acciones()
		game.showAttributes(mainCharacter)
	}
	method spawnManager() {}	
}

object nivel1 inherits Nivel{
	const waveLenght = 4
	var cont = waveLenght
	
	override method spawnManager(){
		if(cont > 0){
			newSpawn.generar(1, self, 1)
			
			cont -= 1
		}else{
			pantallaUpgrade.iniciar()
		}
	}
}

object nivel2 inherits Nivel{
	const waveLenght = 5
	var cont = waveLenght
	
	override method spawnManager(){
		if(cont > 0){
			newSpawn.generar(2, self, 2)
			cont -= 1
		}else{
			pantallaUpgrade.nivel(3)
			pantallaUpgrade.iniciar()
		} 
	}
}

object nivel3 inherits Nivel{
	const waveLenght = 6
	var cont = waveLenght
	
	override method spawnManager(){
		if(cont > 0){
			newSpawn.generar(3, self, 3)
			cont -= 1
		}
	}
}
object pantallaUpgrade {
	var property nivel = 2
	method iniciar() {
		upgradeBackGround.nextlvl(nivel)
		game.clear()
		game.addVisual(upgradeBackGround)
		//Hay que configurar los botones, por ahora el siguente es la felcha derecha
		//Y ASI CON BOTON PARA CONTINUAR Y BOTON PARA MENU PRINCIPAL
		config.next()
	}
	
	method accion(){
		if(nivel == 2){
			nivel2.iniciar()
			mainCharacter.equipUpgrade(2)
		}else{
			nivel3.iniciar()
			mainCharacter.equipUpgrade(3)
		}
		
	}
	
}
object mainMenu {

	var property selected
	const backgroundMusic = game.sound("sounds/introOST.mp3")

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

	method acciones() {
		keyboard.a().onPressDo({ mainCharacter.atacar(mainCharacter.enemigo())})
		keyboard.n().onPressDo({ mainCharacter.enemigo().estado()})
		keyboard.s().onPressDo({ mainCharacter.defender()})
		keyboard.e().onPressDo({ mainCharacter.mostrarStatus()})
	}
	
	method next(){
		keyboard.right().onPressDo({pantallaUpgrade.accion()})
	}
	
}

