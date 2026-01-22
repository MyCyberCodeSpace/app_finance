import 'package:finance_control/core/presentation/widgets/custom_scarfold.dart';
import 'package:finance_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedPageIndex: -1,
      text: 'Sobre o Aplicativo',
      showMenuButton: false,
      onPressedFloatingActionButton: () {},
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.positiveBalance,
                    AppColors.positiveBalance.withValues(alpha: 0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.positiveBalance.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Finance Control',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.gray.shade800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Versão 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray.shade600,
              ),
            ),

            const SizedBox(height: 32),
            _buildInfoCard(
              icon: Icons.info_outline_rounded,
              title: 'Sobre o App',
              description:
                  'Finance Control é um aplicativo de controle financeiro pessoal que permite gerenciar suas receitas, despesas, metas e economias de forma simples e eficiente.',
              color: AppColors.blue,
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.code_rounded,
              title: 'Open Source',
              description:
                  'Este projeto é de código aberto! Você pode visualizar, contribuir e aprender com o código fonte no GitHub.',
              color: AppColors.positiveBalance,
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.security_rounded,
              title: 'Seus Dados são Seguros',
              description:
                  'Todos os seus dados financeiros são armazenados localmente no seu dispositivo. Nenhuma informação é enviada para servidores externos.',
              color: AppColors.orange,
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.gray.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray.shade100,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _launchUrl(
                    'https://github.com/MyCyberCodeSpace/app_finance',
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.gray.shade800.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.link_rounded,
                            color: AppColors.gray.shade800,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Repositório no GitHub',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gray.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Acesse o código fonte',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.gray.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: AppColors.gray.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              '© 2026 Finance Control',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray.shade500,
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.gray.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
