using SistemaGestionNomina.Filters;
using SistemaGestionNomina.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;

namespace SistemaGestionNomina.Controllers
{
    public class SalariosController : Controller
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

        // ✅ GET: Salarios (lista de empleados con salario actual)
        [AuthorizeRole("Admin", "RRHH")]
        public ActionResult Index(int pagina = 1, int registrosPorPagina = 10)
        {
            var empleados = new List<EmpleadoSalarioActual>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM VW_EmpleadosSalarioActual ORDER BY emp_no", conn);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    empleados.Add(new EmpleadoSalarioActual
                    {
                        emp_no = Convert.ToInt32(reader["emp_no"]),
                        ci = reader["ci"].ToString(),
                        first_name = reader["first_name"].ToString(),
                        last_name = reader["last_name"].ToString(),
                        hire_date = Convert.ToDateTime(reader["hire_date"]),
                        salary = Convert.ToInt64(reader["salary"]),
                        from_date = reader["from_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["from_date"]),
                        to_date = reader["to_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["to_date"])
                    });
                }
            }

            // Paginación con Skip y Take
            int totalRegistros = empleados.Count;
            var empleadosPagina = empleados.Skip((pagina - 1) * registrosPorPagina).Take(registrosPorPagina).ToList();

            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling((double)totalRegistros / registrosPorPagina);

            return View(empleadosPagina);
        
        }

        // ✅ GET: Historial de un empleado
        [AuthorizeRole("Admin", "RRHH")]
        public ActionResult Historial(int id)
        {
            var historial = new List<HistorialSalario>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM VW_HistorialSalarios WHERE emp_no=@id", conn);
                cmd.Parameters.AddWithValue("@id", id);

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    historial.Add(new HistorialSalario
                    {
                        emp_no = Convert.ToInt32(reader["emp_no"]),
                        first_name = reader["first_name"].ToString(),
                        last_name = reader["last_name"].ToString(),
                        salary = Convert.ToDecimal(reader["salary"]),
                        from_date = Convert.ToDateTime(reader["from_date"]),
                        to_date = reader["to_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["to_date"])
                    });
                }
            }

            return View(historial); // 👈 Vista recibe historial de 1 empleado
        }

        // GET: Mostrar formulario para asignar salario
        [AuthorizeRole("Admin", "RRHH")]
        public ActionResult AsignarSalario(int emp_no)
        {
            // Traer datos del empleado para mostrar en la vista
            HistorialSalario empleado = null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT TOP 1 e.emp_no, e.first_name, e.last_name FROM employees e WHERE e.emp_no=@id", conn);
                cmd.Parameters.AddWithValue("@id", emp_no);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    empleado = new HistorialSalario
                    {
                        emp_no = Convert.ToInt32(reader["emp_no"]),
                        first_name = reader["first_name"].ToString(),
                        last_name = reader["last_name"].ToString()
                    };
                }
            }

            return View(empleado); // Pasa empleado a la vista
        }

        // POST: Guardar el salario
        [HttpPost]
        public ActionResult AsignarSalario(int emp_no, long new_salary)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_registrarSalario", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@emp_no", emp_no);
                cmd.Parameters.AddWithValue("@new_salary", new_salary);
                cmd.Parameters.AddWithValue("@changed_by", "usuario");

                cmd.ExecuteNonQuery();
            }

            return RedirectToAction("Index");
        }


    }
}

