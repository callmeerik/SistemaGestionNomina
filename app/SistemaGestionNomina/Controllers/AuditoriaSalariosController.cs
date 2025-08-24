using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Mvc;
using SistemaGestionNomina.Models;

namespace TuProyecto.Controllers
{
    public class AuditoriaSalariosController : Controller
    {
        // GET: LogAuditoria
        public ActionResult Index()
        {
            var lista = new List<AuditoriaSalarios>();

            // Obtén la cadena de conexión desde Web.config
            string cnString = ConfigurationManager.ConnectionStrings["Cnn"].ConnectionString;

            string sql = @"SELECT id, usuario, fecha_actualizacion, detalle_cambio, salario, emp_no
                           FROM Log_AuditoriaSalarios
                           ORDER BY fecha_actualizacion DESC";

            using (var cn = new SqlConnection(cnString))
            using (var cmd = new SqlCommand(sql, cn))
            {
                cn.Open();
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        lista.Add(new AuditoriaSalarios
                        {
                            id = rd.GetInt32(0),
                            usuario = rd.GetString(1),
                            fecha_actualizacion = rd.GetDateTime(2),
                            detalle_cambio = rd.GetString(3),
                            salario = rd.GetInt64(4),
                            emp_no = rd.GetInt32(5)
                        });
                    }
                }
            }

            return View(lista);
        }
    }
}
