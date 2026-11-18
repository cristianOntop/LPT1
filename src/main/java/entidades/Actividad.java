
package entidades;

public class Actividad {

    private int id;
    private String nombre;
    private String descripcion;
    private String fechaInicio;
    private String fechaFin;
    private String asesorTecnico;
    private double presupuesto;

    public Actividad(int id, String nombre,
            String descripcion, String fechaInicio,
            String fechaFin, String asesorTecnico,
            double presupuesto) {

        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.asesorTecnico = asesorTecnico;
        this.presupuesto = presupuesto;
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public String getFechaInicio() {
        return fechaInicio;
    }

    public String getFechaFin() {
        return fechaFin;
    }

    public String getAsesorTecnico() {
        return asesorTecnico;
    }

    public double getPresupuesto() {
        return presupuesto;
    }
}
