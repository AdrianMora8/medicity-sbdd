namespace app_02.Views
{
    public class ConsultaGeneral
    {
        public long num { get; set; }
        public int id_cita { get; set; }               // Para PUT /api/medicity/distribuida/{id} y POST /sp_diagnostico
        public int id_paciente { get; set; }           // Para PUT de cita
        public string paciente { get; set; }
        public DateTime fecha_nacimiento { get; set; }
        public string direccion { get; set; }
        public int id_ciudad_paciente { get; set; }
        public string ciudad_paciente { get; set; }
        public int id_doctor { get; set; }             // Para PUT /api/medicity/distribuida/doctor/{id}
        public string doctor { get; set; }
        public int id_ciudad_doctor { get; set; }      // Para PUT /sp_doctor
        public string ciudad_doctor { get; set; }
        public int id_especialidad { get; set; }       // Para PUT /sp_doctor
        public string especialidad { get; set; }
        public DateTime fechahora { get; set; }
        public int? id_diagnostico { get; set; }
        public string nombre_diagnostico { get; set; }
        public string descripcion { get; set; }
        public string tratamiento { get; set; }
    }
}