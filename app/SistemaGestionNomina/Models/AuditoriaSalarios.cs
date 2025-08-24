using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SistemaGestionNomina.Models
{
    public class AuditoriaSalarios
    {
        public int id { get; set; }
        public string usuario { get; set; }
        public DateTime fecha_actualizacion { get; set; }
        public string detalle_cambio { get; set; }
        public long salario { get; set; }
        public int emp_no { get; set; }
    }
}