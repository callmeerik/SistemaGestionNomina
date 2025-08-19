using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SistemaGestionNomina.Controllers
{
    public class AutenticacionController : Controller
    {
        // GET: Autenticacion
        public ActionResult Login()
        {
            return View();
        }
    }
}