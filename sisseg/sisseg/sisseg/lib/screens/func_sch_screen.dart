import 'package:flutter/material.dart';

class SchoolDashboardScreen extends StatelessWidget {
  const SchoolDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Image.network(
                  'https://www.martilor.com/wp-content/uploads/2023/11/logo_corto.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Panel de Control - Colegio',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.purple.shade900,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.purple.shade900,
              const Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen de estadísticas
              Card(
                color: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: _buildStatistic(
                                'Total Alumnos', '250', Icons.people),
                          ),
                          Flexible(
                            child: _buildStatistic(
                                'Alertas Activas', '15', Icons.warning_amber),
                          ),
                          Flexible(
                            child: _buildStatistic(
                                'Informes Pendientes', '5', Icons.assignment),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildMenuCard(
                        context,
                        'Gestión de Alumnos',
                        Icons.people,
                        'Administrar estudiantes',
                        () => Navigator.pushNamed(context, '/students'),
                      ),
                      _buildMenuCard(
                        context,
                        'Estado de Pupilos',
                        Icons.person_search,
                        'Consultar estados',
                        () => Navigator.pushNamed(context, '/pupilstatus'),
                      ),
                      _buildMenuCard(
                        context,
                        'Informes y Vistas',
                        Icons.analytics,
                        'Ver reportes',
                        () => Navigator.pushNamed(context, '/reports'),
                      ),
                      _buildMenuCard(
                        context,
                        'Configuración',
                        Icons.settings,
                        'Ajustes del colegio',
                        () => Navigator.pushNamed(context, '/schoolsettings'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.purple.shade900,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade800,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.network(
                          'https://www.martilor.com/wp-content/uploads/2023/11/logo_corto.png',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Menú de Colegio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                  context,
                  'Inicio',
                  Icons.home,
                  () => Navigator.pop(context, 'roleselection'),
                ),
                _buildDrawerItem(
                  context,
                  'Gestión de Alumnos',
                  Icons.people,
                  () => Navigator.pushNamed(context, '/students'),
                ),
                _buildDrawerItem(
                  context,
                  'Estado de Pupilos',
                  Icons.person_search,
                  () => Navigator.pushNamed(context, '/pupilstatus'),
                ),
                _buildDrawerItem(
                  context,
                  'Ajustes',
                  Icons.settings,
                  () => Navigator.pushNamed(context, '/dashboard'),
                ),
                _buildDrawerItem(
                  context,
                  'Informes y Vistas',
                  Icons.analytics,
                  () => Navigator.pushNamed(context, '/reports'),
                ),
                _buildDrawerItem(
                  context,
                  'Cerrar Sesión',
                  Icons.exit_to_app,
                  () => Navigator.pushReplacementNamed(context, '/login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistic(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
