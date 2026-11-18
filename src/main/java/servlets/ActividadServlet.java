

package servlets;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

import entidades.Actividad;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ActividadServlet")
public class ActividadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final List<Actividad> actividades = new ArrayList<>();

    private int siguienteId = 1;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "registrar";
        }

       
        if ("eliminar".equals(accion)) {

            int id;

            try {
                id = Integer.parseInt(
                        request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendError(400, "ID inválido");
                return;
            }

            boolean eliminado;

            synchronized (actividades) {
                eliminado = actividades.removeIf(
                        a -> a.getId() == id);
            }

            if (!eliminado) {
                response.sendError(
                        404, "Proyecto no encontrado");
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/ActividadServlet");
            return;
        }

    
        if (!"registrar".equals(accion)
                && !"actualizar".equals(accion)) {

            response.sendError(
                    400, "Acción no reconocida");
            return;
        }

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String asesorTecnico = request.getParameter("asesorTecnico");
        String presupuestoTexto =
                request.getParameter("presupuesto");


        if (nombre == null
                || nombre.trim().length() < 4
                || nombre.trim().length() > 60
                || fechaInicio == null
                || fechaInicio.trim().isEmpty()
                || fechaFin == null
                || fechaFin.trim().isEmpty()
                || asesorTecnico == null
                || asesorTecnico.trim().isEmpty()
                || presupuestoTexto == null
                || presupuestoTexto.trim().isEmpty()) {

            response.sendError(
                    400,
                    "Complete correctamente los campos obligatorios");
            return;
        }

   
        try {
            LocalDate inicio = LocalDate.parse(fechaInicio);
            LocalDate fin = LocalDate.parse(fechaFin);

            if (fin.isBefore(inicio)) {
                response.sendError(
                        400,
                        "La fecha de fin no puede ser anterior al inicio");
                return;
            }

        } catch (DateTimeParseException e) {
            response.sendError(
                    400, "Formato de fecha inválido");
            return;
        }

  
        double presupuesto;

        try {
            presupuesto = Double.parseDouble(
                    presupuestoTexto.trim());

            if (!Double.isFinite(presupuesto)
                    || presupuesto < 0) {

                response.sendError(
                        400, "Presupuesto inválido");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    400, "El presupuesto debe ser numérico");
            return;
        }

        if (descripcion == null) {
            descripcion = "";
        }

      
        if ("registrar".equals(accion)) {

            synchronized (actividades) {

                Actividad nueva = new Actividad(
                        siguienteId++,
                        nombre.trim(),
                        descripcion.trim(),
                        fechaInicio,
                        fechaFin,
                        asesorTecnico.trim(),
                        presupuesto
                );

                actividades.add(nueva);
            }
        }

    
        else if ("actualizar".equals(accion)) {

            int id;

            try {
                id = Integer.parseInt(
                        request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendError(
                        400, "Seleccione un proyecto para actualizar");
                return;
            }

            boolean encontrado = false;

            synchronized (actividades) {

                for (int i = 0; i < actividades.size(); i++) {

                    if (actividades.get(i).getId() == id) {

                        Actividad actualizada = new Actividad(
                                id,
                                nombre.trim(),
                                descripcion.trim(),
                                fechaInicio,
                                fechaFin,
                                asesorTecnico.trim(),
                                presupuesto
                        );

                        actividades.set(i, actualizada);
                        encontrado = true;
                        break;
                    }
                }
            }

            if (!encontrado) {
                response.sendError(
                        404, "Proyecto no encontrado");
                return;
            }
        }

      
        response.sendRedirect(
                request.getContextPath()
                + "/ActividadServlet");
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Actividad> copia;

        synchronized (actividades) {
            copia = new ArrayList<>(actividades);
        }

        request.setAttribute("actividades", copia);

        request.getRequestDispatcher("/index.jsp")
               .forward(request, response);
    }
}
