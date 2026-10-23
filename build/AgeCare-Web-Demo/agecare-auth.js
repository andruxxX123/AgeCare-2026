// Cuentas públicas para seleccionar un perfil de ejemplo; no es autenticación real.
const AgeCareAuth = (() => {
  const accounts = Object.freeze({
    'familia@agecare.app': { role: 'Familia', password: 'Familia123!' },
    'cuidador@agecare.app': { role: 'Cuidador', password: 'Cuidador123!', caregiverId:'cg1' },
    'medico@agecare.app': { role: 'Médico', password: 'Medico123!' },
    'elena@agecare.app': { role: 'Adulto mayor', password: 'Adulto123!' },
    'ana@agecare.app': { role:'Cuidador', password:'Ana123!', caregiverId:'cg2' },
    'lucia@agecare.app': { role:'Cuidador', password:'Lucia123!', caregiverId:'cg3' },
    'marta@agecare.app': { role:'Cuidador', password:'Marta123!', caregiverId:'cg4' },
    'patricia@agecare.app': { role:'Cuidador', password:'Patricia123!', caregiverId:'cg5' },
    'carmen@agecare.app': { role:'Cuidador', password:'Carmen123!', caregiverId:'cg6' },
    'daniela@agecare.app': { role:'Cuidador', password:'Daniela123!', caregiverId:'cg7' },
  });

  function authenticate(email, password) {
    if (typeof email !== 'string' || typeof password !== 'string') return null;
    const account = accounts[email.trim().toLowerCase()];
    return account && account.password === password ? account.role : null;
  }

  return Object.freeze({ accounts, authenticate });
})();

if (typeof module !== 'undefined') module.exports = AgeCareAuth;


