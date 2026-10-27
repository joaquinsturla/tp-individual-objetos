class Entrada {
    const property banda
    const fecha
    const precioBase = 1000
    var property impuesto

    method precioAlPublico() = precioBase + impuesto

    method esDelUltimoAnio() {
        const hoy = new Date()
        return fecha >= hoy.minusYears(1) && fecha <= hoy
    }
}

class Asistente {
    var property abono
    const property historialEntradas = []
    var property balance

    method comprarEntrada(entrada) {
        self.validarCompra()
        const costo = abono.calcularPrecio(entrada)
        balance -= costo
        historialEntradas.add(entrada)
    }

    method validarCompra() {
        if (balance <= 0) {
            self.error("No se puede comprar la entrada: saldo insuficiente.")
        }
    }

    method entradasDelUltimoAnio() {
        return historialEntradas.filter({entrada => entrada.esDelUltimoAnio()})
    }

    method bandasVistas() {
        return historialEntradas.map({ entrada => entrada.banda().nombre() }).asSet()
    }

    method calcRecaudacion() {
        return historialEntradas.sum({entrada => entrada.precioAlPublico()})
    } 

    method cantEntradasCompradas() = historialEntradas.size()

    method bonificar() {
      abono.bonificar()
    }
}

object fan {
    method calcularPrecio(entrada) = entrada.precioAlPublico()
    method bonificar() {}
}
class Vip {
    var porcentajeDcto
    
    method calcularPrecio(entrada) = entrada.precioAlPublico() - entrada.precioAlPublico()*porcentajeDcto
    method bonificar() {
        porcentajeDcto += 0.01
    }
}

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
    override method canon() = super()*self.calcPopularidad()

    override method calcPopularidad() {
      if (hielo) {return 1000}
      else {return 0}
    }
}
object productora {
    const asistentes = []
    const bandas = []
 
    method gananciaTotal() {
        const ganancia = asistentes.sum({asistente => asistente.calcRecaudacion()})
        const presupuestoTotal = bandas.sum({banda => banda.calcPresupuesto()})
        return ganancia - presupuestoTotal
    }

    method cantEntradasVendidas() {
        return asistentes.map({asistente => asistente.cantEntradasCompradas()}).sum()
    }

    method bandaMasPopular() {
        return bandas.max({banda => self.entradasVendidasPara(banda)})
    }

    method entradasVendidasPara(banda){
        const todasLasEntradas = asistentes.flatMap({asistente => asistente.historialEntradas()})
        return todasLasEntradas.count({entrada => entrada.banda() == banda}) 
    }

    method modificarVips() {
        asistentes.forEach({asistente => asistente.bonificar()})
    }

}
