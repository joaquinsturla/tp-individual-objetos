
/*🎫 Entradas
Compuestas por una banda y la fecha en la que toca. 
Si bien su precio base es 1000, al precio al público se le tiene que agregar 
el impuesto que fije la productora (el cual es el mismo para todas las entradas 
y podría variar cuando la productora quiera). 
*/
class Entrada {
    const property banda
    const fecha
    const precioBase = 1000
    var property impuesto
    
    method precioAlPublico() = precioBase + impuesto

    method esDelUltimoAnio() {
        const hoy = new Date()
        return (fecha.minusYears(1) <= hoy)
    }
}

/*De cada asistente al show de una banda sabemos el tipo de abono que tiene, el historial 
de entradas (inicialmente no tiene ninguna) y su dinero disponible (que puede ser negativo). 

Si tiene un saldo positivo, debe poder comprar una entrada para una banda en una fecha
en específico. Caso contrario deberá notificarse adecuadamente. El proceso de compra 
no sólo le resta el monto correspondiente a pagar por la entrada a su dinero disponible 
sino que también agrega la entrada a su historial.
El monto a pagar es el precio de la entrada teniendo en cuenta su abono, ya que 
podría otorgarle un porcentaje de descuento.

El abono puede ser fan o vip. El primero no tiene porcentaje de descuento 
y el segundo sí, el cual es particular para cada asistente.

Además, cada asistente deberá poder ver:
Todas las entradas que sacó del año anterior al actual.
El nombre de las bandas por las que compró una entrada.
*/

class registroBandas{
    const bandas = new Dictionary()

    method agregarRegistro(entrada) {
        if (bandas.containsKey(entrada.banda())) {
            bandas.put(entrada.banda(), bandas.get(entrada.banda())+1)
        } else {
            bandas.put(entrada.banda(), 1)
        }
    }

    method bandaMasPopular() {
        bandas.forEach({k, v => })
    }


}

class Asistente {
    var banda 
    var abono
    const property historialEntradas = []
    var balance
    var property porcentajeDcto

    method comprarEntrada(entrada) {
        const costo = abono.calcularPrecio(entrada, porcentajeDcto)
        self.puedeComprarEntrada(costo)
        historialEntradas.add(entrada)
        balance -= costo
    }

    method puedeComprarEntrada(costo) {
        if (balance < 0 || balance < costo){
            error.message("No se puede comprar la entrada")
        }
    }

    method entradasDelUltimoAnio() {
        return historialEntradas.filter({entrada => entrada.esDelUltimoAnio()})
    }

    method bandasVistas() {
        return historialEntradas.map({entrada => entrada.banda()})
    }

    method calcRecaudacion() {
        var suma
        historialEntradas.forEach({entrada => suma = suma + entrada.precioAlPublico()})
        return suma
    } 

    method cantEntradasCompradas() = historialEntradas.size()
}

object fan {
    method calcularPrecio(entrada, dcto) = entrada.precioAlPublico()
}
//tiene que ser una clase?
object vip {
    method calcularPrecio(entrada, dcto) = entrada.precioAlPublico() - entrada.precioAlPublico()*dcto
}

/*Bandas
Sobre las bandas sabemos que todas tienen un nombre y su canon para tocar en un 
show es de 1.000.000. Deben poder calcular su presupuesto y popularidad 
(¡datos importantes para que la productora pueda evaluar traer esa banda!). 
Su presupuesto es el canon más un posible gasto extra:
    🤘 De las bandas de rock sabemos que siempre tienen un gasto extra de 10.000 y su 
        popularidad es 100 veces la cantidad de solos de guitarra que tengan.
    💎 Las bandas de trap no tienen un gasto extra y su popularidad depende de si tienen 
        hielo o no. Si lo tienen, será 1000. Si no, 0. Además su canon es tantas veces 
        su popularidad, siendo diferente al de las otras bandas ya que si no es nada popular, 
        toca gratis para que lo conozcan. Por ejemplo, si la popularidad de Fácil B, un trapero, 
        fuese 1.000 su canon sería 1.000.000.000.
    🎙️ Sobre las bandas indies se sabe que su popularidad es 3,14 veces el largo del 
        nombre de la banda y sus gastos extras son 500 por cada instrumento que tengan.
*/

class Banda {
    const property nombre
    
    method gastoExtra()
    method canon() = 1000000
    method calcPresupuesto() = self.canon() + self.gastoExtra()
    method calcPopularidad()
}

class BandaRock inherits Banda{
    const solosDeGuitarra
    
    override method gastoExtra() = 10000

    override method calcPopularidad() = solosDeGuitarra*100
}

class BandaIndie inherits Banda{
    const cantInstrumentos

    override method gastoExtra() = cantInstrumentos*500
    override method calcPopularidad() = self.nombre().length()*3.14 
}

class BandaTrap inherits Banda{
    const hielo

    override method gastoExtra() = 0
    override method canon() = self.calcPopularidad()

    override method calcPopularidad() {
      if (hielo) {return 1000}
      else {return 0}
    }
}
/*
📋 Finalmente, desde la productora se quieren tener los siguientes reportes:
    La ganancia total, que es la recaudación de las entradas compradas por los asistentes 
        (no te preocupes por el descuento de los vip, ¡para eso están los sponsors!) restando el 
        presupuesto de todas las bandas.
    La cantidad de entradas vendidas.
    La banda más popular, que es la que vendió más entradas.

Además, debe poder bonificar a los asistentes vip. Esto hace que el descuento propio de este abono aumente en 1%.
*/
object productora {
    const asistentes = []
    const bandas = []

    method gananciaTotal() {
        const ganancia
        const presupuestoTotal
        asistentes.map({asistente => asistente.calcRecaudacion()}).sum()
        bandas.map({banda => banda.calcPresupuesto()}).sum()
        return ganancia - presupuestoTotal
    }

    method cantEntradasVendidas() {
        return asistentes.map({asistente => asistente.cantEntradasCompradas()}).sum()
    }

    method modificarAsistente(asistente) {
        asistente.porcentajeDcto(asistente.porcentajeDcto() + asistente.porcentajeDcto()*0.01)
    }

}
