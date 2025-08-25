using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;
using SistemaGestionNomina.Models;



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


        [HttpGet]
        public ActionResult Agregar()
        {
            ViewBag.ActiveTab = "agregar";
            return View("Departamento");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Agregar(Departamento dep)
        {
            if (!ModelState.IsValid) return View("Departamento");
            try
            {
                using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                using (var cmd = new SqlCommand("SPinsertDepartment", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@nombreDepar", dep.nombreDepar);
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    //cn.Close();
                }

                return RedirectToAction("Consultar", "Departamentos");


            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "No se pudo crear el departamento (error de base de datos).");
                return View("Departamento");
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







        [HttpGet]
        public ActionResult AsignarESD()
        {
            var dtEmpl = new DataTable();
            var dtDept = new DataTable();

            try
            {
                using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                {
                    using (var da = new SqlDataAdapter("SPgetEmpleadosSD", cn))
                    {
                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                        da.Fill(dtEmpl);
                    }

                    using (var da2 = new SqlDataAdapter("SPgetDepartmentsActivos", cn))
                    {
                        da2.SelectCommand.CommandType = CommandType.StoredProcedure;
                        da2.Fill(dtDept);
                    }
                }

                // Tabla para la grilla
                ViewBag.AsignarESD = dtEmpl;

                // Combo de departamentos
                var ddl = new List<SelectListItem>();
                foreach (DataRow r in dtDept.Rows)
                {
                    ddl.Add(new SelectListItem
                    {
                        Value = r["dept_no"].ToString(),
                        Text = r["dept_name"].ToString()
                    });
                }
                ViewBag.DepartamentosDDL = ddl;

                ViewBag.ActiveTab = "asignarESD";
                return View("Departamento");
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "No se pudo cargar empleados o departamentos.");
                ViewBag.ActiveTab = "asignarESD";
                return View("Departamento");
            }
        }



        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AsignarDesdeESD(int emp_no, int dept_no_nuevo)
        {
            try
            {
                using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                using (var cmd = new SqlCommand("SPinsertDeptEmpActual", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@emp_no", emp_no);
                    cmd.Parameters.AddWithValue("@dept_no", dept_no_nuevo);
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }

                TempData["ok"] = "Asignación realizada.";
                return Redirect(Url.Action("AsignarESD", "Departamentos") + "#asignarESD");
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                TempData["err"] = "No se pudo asignar el departamento.";
                return Redirect(Url.Action("AsignarESD", "Departamentos") + "#asignarESD");
            }
        }




        // Gestor para asginar departamentos
        private List<SelectListItem> LoadDepartamentosDDL(int? excluirDeptNo = null)
        {
            var dt = new DataTable();
            using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
            using (var da = new SqlDataAdapter("SPgetDepartmentsActivos", cn))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                da.Fill(dt);
            }

            var ddl = new List<SelectListItem>();
            foreach (DataRow r in dt.Rows)
            {
                var val = r["dept_no"].ToString();
                if (excluirDeptNo.HasValue && val == excluirDeptNo.Value.ToString()) continue; // opcional: quita el actual
                ddl.Add(new SelectListItem { Value = val, Text = r["dept_name"].ToString() });
            }
            return ddl;
        }


        [HttpGet]
        public ActionResult Asignar()
        {
            ViewBag.DepartamentosDDL = LoadDepartamentosDDL();
            ViewBag.ActiveTab = "asignar";
            return View("Departamento");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Asignar(Departamento dep, string accion, int? emp_no, int? dept_no_actual, int? dept_no_nuevo)
        {
            ViewBag.ActiveTab = "asignar";
            var dt_consultar = new DataTable();

            try
            {
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

                    if (dt_consultar.Rows.Count > 0)
                    {
                        var r = dt_consultar.Rows[0];
                        var empNo = Convert.ToInt32(r["Id"]);
                        var deptAct = Convert.ToInt32(r["Id_Departamento"]);

                        ViewBag.EmpNo = empNo;
                        ViewBag.DeptNoActual = deptAct;

                        // DDL sin el departamento actual (opcional)
                        ViewBag.DepartamentosDDL = LoadDepartamentosDDL(deptAct);
                    }
                    else
                    {
                        // Sin resultados: igual mostramos el combo completo
                        ViewBag.DepartamentosDDL = LoadDepartamentosDDL();
                    }

                    return View("Departamento");
                }

                if (string.Equals(accion, "asignar", StringComparison.OrdinalIgnoreCase))
                {
                    if (emp_no == null || dept_no_actual == null || dept_no_nuevo == null)
                    {
                        ModelState.AddModelError("", "Faltan datos. Primero pulsa 'Consultar'.");
                        ViewBag.DepartamentosDDL = LoadDepartamentosDDL(dept_no_actual);
                        return View("Departamento");
                    }
                    if (dept_no_actual == dept_no_nuevo)
                    {
                        ModelState.AddModelError("", "El nuevo departamento no puede ser igual al actual.");
                        ViewBag.DepartamentosDDL = LoadDepartamentosDDL(dept_no_actual);
                        return View("Departamento");
                    }

                    using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString))
                    using (var cmd = new SqlCommand("SPsetAsigDepartEmpl", cn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@emp_no", emp_no.Value);
                        //cmd.Parameters.AddWithValue("@dept_no", dept_no_actual.Value);
                        cmd.Parameters.AddWithValue("@dept_no_nuevo", dept_no_nuevo.Value);
                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    TempData["ok"] = "Asignación realizada.";
                    return RedirectToAction("Historial", "Departamentos");
                }

                ModelState.AddModelError("", "Acción no reconocida.");
                ViewBag.DepartamentosDDL = LoadDepartamentosDDL();
                return View("Departamento");
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
                ModelState.AddModelError("", "Error de base de datos.");
                ViewBag.DepartamentosDDL = LoadDepartamentosDDL(dept_no_actual);
                return View("Departamento");
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