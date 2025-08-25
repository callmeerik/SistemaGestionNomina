using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SistemaGestionNomina.Models
{
    public class Dashboard
    {
        public int total_empleados {  get; set; }
        public int total_departamentos { get; set; }
        public long promedio_salario { get; set; }
        public Dictionary<string, int> genero {  get; set; }
        public Dictionary<string , int> empleados_dept {  get; set; }
        public Dictionary<string, long> salario_dept { get; set; } 

        public Dashboard()
        {
            genero = new Dictionary<string , int>();
            empleados_dept = new Dictionary<string, int>();
            salario_dept = new Dictionary<string , long>();
        }
    }
}