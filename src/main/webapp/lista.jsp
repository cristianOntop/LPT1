
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

    <title>Lista de Proyectos</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>

<body class="bg-light">

<div class="container py-5">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">
                Proyectos Registrados
            </h3>
        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-bordered table-striped">

                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Inicio</th>
                            <th>Fin</th>
                            <th>Asesor Técnico</th>
                            <th>Presupuesto</th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                        List<Actividad> actividades =
                            (List<Actividad>) request.getAttribute("actividades");

                        if (actividades != null) {

                            for (Actividad a : actividades) {
                    %>

                        <tr>
                            <td><%= a.getId() %></td>

                            <td><%= escapar(a.getNombre()) %></td>

                            <td><%= escapar(a.getDescripcion()) %></td>

                            <td><%= escapar(a.getFechaInicio()) %></td>

                            <td><%= escapar(a.getFechaFin()) %></td>

                            <td><%= escapar(a.getAsesorTecnico()) %></td>

                            <td>
                                S/ <%= String.format(
                                    java.util.Locale.US,
                                    "%,.2f",
                                    a.getPresupuesto()
                                ) %>
                            </td>
                        </tr>

                    <%
                            }
                        }
                    %>

                    </tbody>

                </table>

            </div>

            <a href="${pageContext.request.contextPath}/index.jsp"
               class="btn btn-success">
                Registrar Nuevo Proyecto
            </a>

        </div>
    </div>

</div>

</body>
</html>
