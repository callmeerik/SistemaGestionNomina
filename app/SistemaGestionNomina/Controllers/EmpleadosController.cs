using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;
using SistemaGestionNomina.Models;

namespace SistemaGestionNomina.Controllers
{
    public class EmpleadosController : Controller
    {
        // GET: Empleados
        public ActionResult Index(string query, string estado = "Todos", int pagina = 1, int numElementosPg = 10)
        {
            List<Empleados> empleados = new List<Empleados>();

            try
            {
                using ( SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString ) )
                {
                    // llamado al procedure
                    SqlCommand cmd = new SqlCommand("sp_getEmployees", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    //parametros para busqueda y filtrado
                    cmd.Parameters.AddWithValue("query", string.IsNullOrEmpty(query) ? (object)DBNull.Value : query);
                    cmd.Parameters.AddWithValue("estado", string.IsNullOrEmpty(estado) ? (object)DBNull.Value : estado);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        Empleados emp = new Empleados
                        {
                            emp_no = Convert.ToInt32(reader["emp_no"]),
                            ci = reader["ci"].ToString(),
                            birth_date = reader["birth_date"].ToString(),
                            first_name = reader["first_name"].ToString(),
                            last_name = reader["last_name"].ToString(),
                            gender = Convert.ToChar(reader["gender"]),
                            correo = reader["correo"].ToString(),
                            hire_date = reader["hire_date"].ToString(),
                            is_active = Convert.ToBoolean(reader["is_active"])
                        };
                        empleados.Add( emp );
                    }
                }

                //paginacion
                int totalEmpleados = empleados.Count;
                var empleadosPagina = empleados
                    .Skip((pagina - 1) * numElementosPg)
                    .Take(numElementosPg)
                    .ToList();

                // datos para la vista
                ViewBag.PaginaActual = pagina;
                ViewBag.PaginaTamanio = numElementosPg;
                ViewBag.TotalItems = totalEmpleados;
                ViewBag.Busqueda = query;
                ViewBag.Estado = estado;

                return View(empleadosPagina);
            }
            catch (SqlException ex)
            {
                ViewBag.Error = ex.Message;
                return View(new List<Empleados>());
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = "Ocurrió un error inesperado: " + ex.Message;
                return View(new List<Empleados>());
            }

        }
    }
}