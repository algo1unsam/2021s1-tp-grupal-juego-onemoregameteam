import wollok.game.*
import equipamento.*
import niveles.*
import entidades.*


 const accionConjDer = new AccionConj(charact = mainCharacter,enemigo = mainCharacter.enemigo())
 
 object accionConjizq inherits AccionConj(charact =mainCharacter.enemigo(), enemigo = mainCharacter){
	
	override method caminar(){
		modoWalkingL.accion(charact)
	}
	
	override method volver(){
		modoWalkingR.accion(charact)
	}
}
 
class Modo {

    var property descripcion 
    var property velocidad
    var property pasos
	var property time
	var property final
	
    method accionPersonaje(charact){
		self.moverPersonaje(charact)
				
        if (self.time() == pasos) {
        	game.removeTickEvent(descripcion)   	
			time = final
        }
        
    }

	method accion(charact) {
		game.onTick(velocidad, descripcion, {=> self.accionPersonaje(charact)})
		
	}
	
	method moverPersonaje(charact){		
	}
	
}
object modoWalkingR inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 14, time=0,final=0) {

    override method moverPersonaje(charact){
    	time+=1
        charact.position(charact.position().right(1))
       
    }    
}
object modoWalkingL inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 0, time=14,final=14) {

    override method moverPersonaje(charact){
		time -=1
        charact.position(charact.position().left(1))
    }
}

class AccionConj{
	
	var property charact
	var property enemigo
	
	method caminar(){
		modoWalkingR.accion(charact)
	}
	method volver(){
		modoWalkingL.accion(charact)
	}
	method accion(){
		self.caminar()
		game.schedule(1500,{self.volver()})	
	}
}
