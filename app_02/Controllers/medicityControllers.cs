using app_02.DTO;
using app2.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace app2.Controllers
{
    [Route("api/medicity/distribuida")]
    [ApiController]
    public class medicityControllers : ControllerBase
    {
        private readonly AppDbContext _context;

        public medicityControllers(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("view")]
        public async Task<IActionResult> GetProductosView()
        {
            var productos = await _context.ConsultaGeneral.ToListAsync();

            return Ok(productos);
        }

        [HttpGet("doctores")]
        public async Task<IActionResult> GetDoctoresView()
        {
            var doctores = await _context.VistaDoctores.ToListAsync();

            return Ok(doctores);
        }

        [HttpGet("diagnosticos")]
        public async Task<IActionResult> GetDiagnosticosView()
        {
            var diagnosticos = await _context.VistaDiagnosticos.ToListAsync();

            return Ok(diagnosticos);
        }

        [HttpGet("pacientes")]
        public async Task<IActionResult> GetPacientesView()
        {
            var pacientes = await _context.VistaPacientes.ToListAsync();

            return Ok(pacientes);
        }

        [HttpGet("citas")]
        public async Task<IActionResult> GetCitasView()
        {
            var citas = await _context.VistaCitas.ToListAsync();

            return Ok(citas);
        }

        [HttpPost("sp_doctor")]
        public async Task<IActionResult> CrearDoctor(DoctorCrearDto doctor)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_InsertarDoctor
                    @NOMBRE = {doctor.Nombre},
                    @ID_ESPECIALIDAD = {doctor.IdEspecialidad},
                    @ID_CIUDAD = {doctor.IdCiudad}
            ");

                return Ok(new
                {
                    mensaje = "Doctor registrado correctamente"
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> ActualizarCita(
        int id, UpdateCItasDto cita)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_ActualizarCitaMedica
                    @ID = {id},
                    @ID_PACIENTE = {cita.IdPaciente},
                    @ID_DOCTOR = {cita.IdDoctor},
                    @FECHAHORA = {cita.FechaHora}
            ");

                return Ok(new
                {
                    mensaje = "Cita médica actualizada correctamente"
                });
            }
            catch (SqlException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }


        [HttpPost("sp_diagnostico")]
        public async Task<IActionResult> CrearDiagnostico(DiagnosticoCrearDto diagnostico)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_InsertarDiagnostico
                    @ID_CITA = {diagnostico.IdCita},
                    @NOMBRE = {diagnostico.Nombre},
                    @DESCRIPCION = {diagnostico.Descripcion},
                    @TRATAMIENTO = {diagnostico.Tratamiento}
            ");

                return Ok(new
                {
                    mensaje = "Diagnóstico registrado correctamente"
                });
            }
            catch (SqlException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

        [HttpPut("doctor/{id}")]
        public async Task<IActionResult> ActualizarDoctor(int id, DoctorActualizarDto doctor)
        {
            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($@"
                EXEC sp_ActualizarDoctor
                    @ID = {id},
                    @NOMBRE = {doctor.Nombre},
                    @ID_ESPECIALIDAD = {doctor.IdEspecialidad},
                    @ID_CIUDAD = {doctor.IdCiudad}
            ");

                return Ok(new
                {
                    mensaje = "Doctor actualizado correctamente"
                });
            }
            catch (SqlException ex)
            {
                return BadRequest(new
                {
                    mensaje = ex.Message
                });
            }
        }

    }
}

/*[HttpPost("sp")]
public async Task<IActionResult> CreateProductoSP(Product product)
{
    await _context.Database.ExecuteSqlInterpolatedAsync(
        $"EXEC products_insert_sp @names={product.Names}, @price={product.Price}, @stock={product.Stock}"
    );

    return Ok("Producto creado correctamente");
}*/





