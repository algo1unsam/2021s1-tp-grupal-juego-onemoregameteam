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
		keyboard.n().onPressDo({mainCharacter.enemigo().estado()})
}
}
