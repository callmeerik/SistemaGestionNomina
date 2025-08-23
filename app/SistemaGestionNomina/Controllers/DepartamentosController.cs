using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SistemaGestionNomina.Models;
using System.Security.Cryptography;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;



namespace SistemaGestionNomina.Controllers
{
    public class DepartamentosController : Controller
    {
        [HttpGet]
        public ActionResult Departamento()
        {
            //return RedirectToAction("Agregar");
            return View("Departamento");
        }

        // Gestor para agregar departamentos


        public ActionResult Agregar()
        {
            ViewBag.ActiveTab = "agregar";
            return View("Departamento");
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Agregar(Departamento dep)
        {
            if (!ModelState.IsValid) return View("Departamento", dep);
            try
            {
                using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                using (var cmd = new SqlCommand("SPinsertDepartment", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@nombreDepar", dep.nombreDepar);
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    cn.Close();
                }

                return RedirectToAction("Consultar", "Departamentos");


            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "No se pudo crear el departamento (error de base de datos).");
                return View("Departamento", dep);
            }
        }









        //Gestor de Consultas de Departamentos

        [HttpGet]

        public ActionResult Consultar()
        {
            var dt_consultar = new DataTable();

            try
            {
                using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                using (var da = new SqlDataAdapter("SPgetDepartments", cn)) // tu SP
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.Fill(dt_consultar);
                }

                ViewBag.Departamentos = dt_consultar;      // <-- pasamos DataTable
                ViewBag.ActiveTab = "consultar"; // para dejar activa la pestaña
                Session["DeptSection"] = "consultar";
                return View("Departamento");
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "No se pudo consultar los departamentos.");
                ViewBag.ActiveTab = "consultar";
                return View("Departamento");
            }
        }

        [HttpPost]








        // Gestor para asginar departamentos

        [HttpGet]
        public ActionResult Asignar()
        {
            ViewBag.ActiveTab = "asignar";
            return View("Departamento");
        }
        public ActionResult Asignar(Departamento dep, string accion, int? emp_no, int? dept_no_actual, int? dept_no_nuevo)
        {
            ViewBag.ActiveTab = "asignar";
            var dt_consultar = new DataTable();

            try
            {
                // Consultar 
                if (string.Equals(accion, "consultar", StringComparison.OrdinalIgnoreCase))
                {
                    using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                    using (var cmd = new SqlCommand("SPgetAsigDepartEmpl", cn))
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ci", dep.cedulaEmpl ?? (object)DBNull.Value);
                        da.Fill(dt_consultar);
                    }

                    ViewBag.Asignar = dt_consultar;
                    ViewBag.CedulaEmpl = dep.cedulaEmpl;

                    // Se debe agregar pregunta de fecha null para tomar el departamento actual correcto
                    if (dt_consultar.Rows.Count > 0)
                    {
                        var r = dt_consultar.Rows[0];

                        // Conecta con SP y utiliza los campos despues nombrados como AS                                         
                        ViewBag.EmpNo = Convert.ToInt32(r["Id"]);
                        ViewBag.DeptNoActual = Convert.ToInt32(r["Id_Departamento"]);

                    }
                    //return RedirectToAction("Asignar");
                    //return View("Departamento", dep);
                    //return Redirect(Url.Action("Asignar", "Departamentos") + "#asignar");
                    //return Redirect(Url.Action("Asignar", "Departamentos", new { ci = dep.cedulaEmpl }) + "#asignar");

                }



                ViewBag.ActiveTab = "asignar";
                //  Realiza validaciones y usa los paremetros SP tal cual: @emp_no, @dept_no, @dept_no_nuevo)
                if (string.Equals(accion, "asignar", StringComparison.OrdinalIgnoreCase))
                {
                    if (emp_no == null || dept_no_actual == null || dept_no_nuevo == null)
                    {
                        ModelState.AddModelError("", "Faltan datos. Primero pulsa 'Consultar'.");
                        return View("Departamento", dep);
                    }
                    if (dept_no_actual == dept_no_nuevo)
                    {
                        ModelState.AddModelError("", "El nuevo departamento no puede ser igual al actual.");
                        return View("Departamento", dep);
                    }

                    using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                    using (var cmd = new SqlCommand("SPsetAsigDepartEmpl", cn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@emp_no", emp_no.Value);
                        cmd.Parameters.AddWithValue("@dept_no", dept_no_actual.Value);
                        cmd.Parameters.AddWithValue("@dept_no_nuevo", dept_no_nuevo.Value);
                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    TempData["ok"] = "Asignación realizada.";


                    // Se podria reconsultar para actualizar la tabla

                    //return RedirectToAction("Asignar");
                    return RedirectToAction("Historial", "Departamentos");

                }

                // Fallback
                ModelState.AddModelError("", "Acción no reconocida.");
                //return View("Departamento", dep);
                return View("Departamento");
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "Error de base de datos.");
                return View("Departamento", dep);
            }
        }






        // Consulta de historial de cambios de departamentos por empleados

        [HttpGet]

        public ActionResult Historial()
        {
            var dt_historial = new DataTable();

            try
            {
                using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                using (var da = new SqlDataAdapter("SPgetDept_manager", cn)) // tu SP
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.Fill(dt_historial);
                }

                ViewBag.Historial = dt_historial;      // <-- pasamos DataTable historial
                ViewBag.ActiveTab = "historial"; // para dejar activa la pestaña
                Session["DeptSection"] = "historial";
                return View("Departamento");
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "No se pudo consultar el historial.");
                ViewBag.ActiveTab = "historial";
                return View("Departamento");
            }
        }
    }
}