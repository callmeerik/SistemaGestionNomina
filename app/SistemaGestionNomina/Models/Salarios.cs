using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace SistemaGestionNomina.Models
{
    // Modelo para la vista VW_EmpleadosSalarioActual
    public class EmpleadoSalarioActual
    {
        public int emp_no { get; set; }
        public string ci { get; set; }
        public string first_name { get; set; }
        public string last_name { get; set; }
        public DateTime hire_date { get; set; }
        public decimal salary { get; set; }
        public DateTime from_date { get; set; }
        public DateTime to_date { get; set; }
    }

    // Modelo para la vista VW_HistorialSalarios
    public class HistorialSalario
    {
        public int emp_no { get; set; }
        public string first_name { get; set; }
        public string last_name { get; set; }
        public decimal salary { get; set; }
        public DateTime from_date { get; set; }
        public DateTime to_date { get; set; }
    }
}
