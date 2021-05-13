import entidades.*
import wollok.game.*
import equipamento.*

object nivel1{
	method iniciar() {
		game.addVisual(mainCharacter)
		spawn.generar()
		config.configurarTeclas()
	}
}

object config{
	method configurarTeclas(){
		keyboard.a().onPressDo({mainCharacter.atacar(mainCharacter.enemigo())})
		//una vez derrotado un enemigo para que se genere otro hay que apretar 'N' como 'siguiente'
		//sin animacion la generacion se siente antinatural
		keyboard.n().onPressDo({mainCharacter.enemigo().estado()})
}
}
