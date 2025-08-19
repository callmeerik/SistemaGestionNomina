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
using System.Net.Configuration;

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
                ViewBag.Error = "Error en base de datos: " + ex.Message;
                return View(new List<Empleados>());
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = "Ocurrió un error inesperado: " + ex.Message;
                return View(new List<Empleados>());
            }

        }

        [HttpPost]
        public ActionResult CambiarEstado(int emp_no)
        {
            // Validacion en caso de que no se pase vlaores correctos al metodo
            if ( emp_no <= 0 )
            {
                return View("Index");
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("sp_updateEmployeeState", conn);
                    
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@emp_no", emp_no);
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                TempData["Message"] = "Estado actualizado correctamente.";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error al actualizar estado: " + ex.Message;
            }

            return RedirectToAction("Index");
        }

        [HttpGet]
        public ActionResult EditarEmpleado(int emp_no)
        {
            Empleados emp = null;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("sp_getEmployeeById", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@emp_no", emp_no);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        emp = new Empleados
                        {
                            emp_no = Convert.ToInt32(reader["emp_no"]),
                            ci = reader["ci"].ToString(),
                            first_name = reader["first_name"].ToString(),
                            last_name = reader["last_name"].ToString(),
                            correo = reader["correo"].ToString(),
                            gender = reader["gender"].ToString()[0],
                            birth_date = reader["birth_date"].ToString(),
                            hire_date = reader["hire_date"].ToString(),
                            is_active = (bool)reader["is_active"]
                        };
                            
                    }
                }
                if (emp == null)
                    TempData["Error"] = "Empleado no encontrado.";
            }
            catch (SqlException ex)
            {
                TempData["Error"] = ex.Message;
            }
            return View(emp);
        }

        [HttpPost]
        public ActionResult EditarEmpleado(Empleados emp)
        {
            if (!ModelState.IsValid)
            {
                return View(emp);
            }

            try
            {
                using ( SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString ))
                {
                    SqlCommand cmd = new SqlCommand("sp_UpdateEmployee", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("emp_no", emp.emp_no);
                    cmd.Parameters.AddWithValue("ci", emp.ci);
                    cmd.Parameters.AddWithValue("first_name", emp.first_name);
                    cmd.Parameters.AddWithValue("last_name", emp.last_name);
                    cmd.Parameters.AddWithValue("correo", emp.correo);
                    cmd.Parameters.AddWithValue("gender", emp.gender);
                    cmd.Parameters.AddWithValue("birth_date", emp.birth_date);
                    conn.Open();    
                    cmd.ExecuteNonQuery();

                    conn.Close();
                }

                TempData["Mensaje"] = "Empleado actualizado correctamente";
                return RedirectToAction("Index");
            }
            catch (SqlException ex)
            {
                TempData["Error"] = $"Error al actualizar a empleado: {ex.Message}";
                return View(emp);
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Error al actualizar a empleado: {ex.Message}";
                return View(emp);
            }
        }


    }
}