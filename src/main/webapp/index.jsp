
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="entidades.Actividad" %>

<%!
    private String escapar(String valor) {
        if (valor == null) return "";

        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Proyectos de Inversión Pública</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        .fila-seleccionada td {
            background-color: #d9ecff !important;
        }

        .fila-proyecto {
            cursor: pointer;
        }
    </style>
</head>

<body class="bg-white">

<div class="container-fluid px-4 py-4">
 
 		<h2 class="text-center fw-bold mb-4">
        Proyectos de Inversión Pública
    	</h2>
    	
    <div class="row g-4">

        <!-- FORMULARIO -->
        <div class="col-lg-5">

            <h4 class="mb-3">Registrar Proyecto</h4>

            <form id="formProyecto"
                  action="${pageContext.request.contextPath}/ActividadServlet"
                  method="post">

                <!-- ID DEL PROYECTO SELECCIONADO -->
                <input type="hidden" name="id" id="idProyecto">

                <!-- ACCIÓN: REGISTRAR, ACTUALIZAR O ELIMINAR -->
                <input type="hidden"
                       name="accion"
                       id="accionProyecto"
                       value="registrar">

                <div class="mb-3">
                    <label class="form-label">
                        Nombre del Proyecto
                    </label>

                    <input type="text"
                           id="nombre"
                           name="nombre"
                           class="form-control"
                           minlength="4"
                           maxlength="60"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Descripción técnica del Proyecto (Opcional)
                    </label>

                    <textarea id="descripcion"
                              name="descripcion"
                              class="form-control"
                              rows="3"></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Fecha de inicio del Proyecto
                    </label>

                    <input type="date"
                           id="fechaInicio"
                           name="fechaInicio"
                           class="form-control"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Fecha de culminación del Proyecto
                    </label>

                    <input type="date"
                           id="fechaFin"
                           name="fechaFin"
                           class="form-control"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Asesor Técnico del Proyecto
                        (Nombres y Apellidos)
                    </label>

                    <input type="text"
                           id="asesorTecnico"
                           name="asesorTecnico"
                           class="form-control"
                           required>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        Presupuesto Asignado
                    </label>

                    <input type="number"
                           id="presupuesto"
                           name="presupuesto"
                           class="form-control"
                           min="0"
                           step="0.01"
                           required>
                </div>

                <!-- BOTONES HABILITADOS -->
                <div class="d-flex gap-2 flex-wrap">

                    <button type="button"
                            class="btn btn-primary"
                            onclick="registrarProyecto()">
                        Registrar
                    </button>

                    <button type="button"
                            class="btn btn-info text-white"
                            onclick="actualizarProyecto()">
                        Actualizar
                    </button>

                    <a href="${pageContext.request.contextPath}/ActividadServlet"
                       class="btn btn-warning">
                        Listar
                    </a>

                    <button type="button"
                            class="btn btn-danger"
                            onclick="eliminarProyecto()">
                        Eliminar
                    </button>

                </div>

                <div class="mt-3">
                    <small id="mensajeSeleccion"
                           class="text-muted">
                        Selecciona una fila de la tabla para actualizar
                        o eliminar un proyecto.
                    </small>
                </div>

            </form>

        </div>

        <!-- TABLA -->
        <div class="col-lg-7">

            <h4 class="mb-3">Proyectos Disponibles</h4>

            <div class="table-responsive">

                <table class="table table-bordered table-striped table-sm align-middle">

                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Nombre del Proyecto</th>
                            <th>Inicio</th>
                            <th>Fin</th>
                            <th>Asesor Técnico</th>
                            <th>Presupuesto</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                        List<Actividad> actividades =
                            (List<Actividad>)
                            request.getAttribute("actividades");

                        if (actividades != null
                                && !actividades.isEmpty()) {

                            for (Actividad a : actividades) {
                    %>

                        <tr class="fila-proyecto"
                            onclick="seleccionarProyecto(this)"
                            data-id="<%= a.getId() %>"
                            data-nombre="<%= escapar(a.getNombre()) %>"
                            data-descripcion="<%= escapar(a.getDescripcion()) %>"
                            data-inicio="<%= escapar(a.getFechaInicio()) %>"
                            data-fin="<%= escapar(a.getFechaFin()) %>"
                            data-asesor="<%= escapar(a.getAsesorTecnico()) %>"
                            data-presupuesto="<%= a.getPresupuesto() %>">

                            <td><%= a.getId() %></td>

                            <td>
                                <%= escapar(a.getNombre()) %>
                            </td>

                            <td>
                                <%= escapar(a.getFechaInicio()) %>
                            </td>

                            <td>
                                <%= escapar(a.getFechaFin()) %>
                            </td>

                            <td>
                                <%= escapar(a.getAsesorTecnico()) %>
                            </td>

                            <td>
                                S/ <%= String.format(
                                    java.util.Locale.US,
                                    "%,.2f",
                                    a.getPresupuesto()
                                ) %>
                            </td>

                            <!-- ACCIONES -->
                            <td class="text-center text-nowrap">

                                <!-- INFORMACIÓN -->
                                <button type="button"
                                        class="btn btn-sm btn-outline-dark"
                                        title="Ver información"
                                        onclick="event.stopPropagation(); mostrarProyecto(this.closest('tr'))">
                                    &#9432;
                                </button>

                                <!-- PAPELERA -->
                                <form action="${pageContext.request.contextPath}/ActividadServlet"
                                      method="post"
                                      class="d-inline"
                                      onclick="event.stopPropagation()"
                                      onsubmit="return confirm('¿Seguro que deseas eliminar este proyecto?');">

                                    <input type="hidden"
                                           name="accion"
                                           value="eliminar">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= a.getId() %>">

                                    <button type="submit"
                                            class="btn btn-sm btn-outline-danger"
                                            title="Eliminar proyecto">
                                        &#128465;
                                    </button>

                                </form>

                            </td>

                        </tr>

                    <%
                            }
                        } else {
                    %>

                        <tr>
                            <td colspan="7"
                                class="text-center text-muted">
                                No hay proyectos registrados
                            </td>
                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

<!-- MODAL DE INFORMACIÓN -->
<div class="modal fade"
     id="modalProyecto"
     tabindex="-1"
     aria-hidden="true">

    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">
                    Información del Proyecto
                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar"></button>
            </div>

            <div class="modal-body">

                <p><strong>ID:</strong>
                    <span id="detalleId"></span>
                </p>

                <p><strong>Nombre:</strong>
                    <span id="detalleNombre"></span>
                </p>

                <p><strong>Descripción:</strong>
                    <span id="detalleDescripcion"></span>
                </p>

                <p><strong>Fecha de inicio:</strong>
                    <span id="detalleInicio"></span>
                </p>

                <p><strong>Fecha de culminación:</strong>
                    <span id="detalleFin"></span>
                </p>

                <p><strong>Asesor Técnico:</strong>
                    <span id="detalleAsesor"></span>
                </p>

                <p><strong>Presupuesto:</strong>
                    S/ <span id="detallePresupuesto"></span>
                </p>

            </div>

            <div class="modal-footer">
                <button type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">
                    Cerrar
                </button>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

// SELECCIONAR PROYECTO DESDE LA TABLA
function seleccionarProyecto(fila) {

    document.querySelectorAll(".fila-proyecto")
        .forEach(function(elemento) {
            elemento.classList.remove("fila-seleccionada");
        });

    fila.classList.add("fila-seleccionada");

    document.getElementById("idProyecto").value =
        fila.dataset.id;

    document.getElementById("nombre").value =
        fila.dataset.nombre;

    document.getElementById("descripcion").value =
        fila.dataset.descripcion;

    document.getElementById("fechaInicio").value =
        fila.dataset.inicio;

    document.getElementById("fechaFin").value =
        fila.dataset.fin;

    document.getElementById("asesorTecnico").value =
        fila.dataset.asesor;

    document.getElementById("presupuesto").value =
        fila.dataset.presupuesto;

    document.getElementById("mensajeSeleccion").textContent =
        "Proyecto seleccionado: ID " + fila.dataset.id;
}

// REGISTRAR PROYECTO
function registrarProyecto() {

    const formulario =
        document.getElementById("formProyecto");

    document.getElementById("accionProyecto").value =
        "registrar";

    if (formulario.reportValidity()) {
        formulario.submit();
    }
}

// ACTUALIZAR PROYECTO
function actualizarProyecto() {

    const id =
        document.getElementById("idProyecto").value;

    if (!id) {
        alert("Primero selecciona un proyecto de la tabla.");
        return;
    }

    const formulario =
        document.getElementById("formProyecto");

    document.getElementById("accionProyecto").value =
        "actualizar";

    if (formulario.reportValidity()) {
        formulario.submit();
    }
}

// ELIMINAR PROYECTO DESDE EL BOTÓN ROJO
function eliminarProyecto() {

    const id =
        document.getElementById("idProyecto").value;

    if (!id) {
        alert("Primero selecciona un proyecto de la tabla.");
        return;
    }

    if (!confirm("¿Seguro que deseas eliminar este proyecto?")) {
        return;
    }

    document.getElementById("accionProyecto").value =
        "eliminar";

    document.getElementById("formProyecto").submit();
}

// VER INFORMACIÓN DEL PROYECTO
function mostrarProyecto(fila) {

    document.getElementById("detalleId").textContent =
        fila.dataset.id;

    document.getElementById("detalleNombre").textContent =
        fila.dataset.nombre;

    document.getElementById("detalleDescripcion").textContent =
        fila.dataset.descripcion || "Sin descripción";

    document.getElementById("detalleInicio").textContent =
        fila.dataset.inicio;

    document.getElementById("detalleFin").textContent =
        fila.dataset.fin;

    document.getElementById("detalleAsesor").textContent =
        fila.dataset.asesor;

    const presupuesto =
        Number(fila.dataset.presupuesto);

    document.getElementById("detallePresupuesto").textContent =
        presupuesto.toLocaleString("es-PE", {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });

    const modal = new bootstrap.Modal(
        document.getElementById("modalProyecto")
    );

    modal.show();
}

</script>

</body>
</html>
