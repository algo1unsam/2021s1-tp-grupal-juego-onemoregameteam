import entidades.*
import wollok.game.*
import equipamento.*
import mainMenu.*

object nivel1{
	method iniciar() {
		game.clear()
		game.addVisual(mainCharacter)
		spawn.generar()
		config.configurarTeclas()
	}
}

object mainMenu{
	var property selected
	var backgroundMusic = game.sound("sounds/introOST.mp3")
	method iniciar() {
		game.clear()
		//game.cellSize()
		game.addVisual(menuBackground)
		game.addVisual(start)
		game.addVisual(quit)
		self.introMusic()
		config.configMainMenu()
	}
	
	method down(){
		if(quit.selected()){
			self.selected(start)
		} else self.selected(quit)
	}
	method up(){
		if(start.selected()){
			self.selected(quit)
		} else self.selected(start)
	}
	method action(){
		selected.action()
	}
	
	method introMusic(){
		game.schedule(100,{ backgroundMusic.play() })
	}
}

object config{
	method configMainMenu(){
		keyboard.up().onPressDo({mainMenu.up()})
		keyboard.down().onPressDo({mainMenu.down()})
		keyboard.enter().onPressDo({mainMenu.action()})
	}
	
	method configurarTeclas(){
		keyboard.a().onPressDo({mainCharacter.atacar(mainCharacter.enemigo())})
		//una vez derrotado un enemigo para que se genere otro hay que apretar 'N' como 'siguiente'
		//sin animacion la generacion se siente antinatural
		keyboard.n().onPressDo({mainCharacter.enemigo().estado()})
}
}
