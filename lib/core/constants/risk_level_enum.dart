/// Risk seviyesi filtreleme için enum
enum RiskLevelFilter {
  all('Tümü'),
  high('YÜKSEK'),
  medium('ORTA'),
  low('DÜŞÜK');

  const RiskLevelFilter(this.displayName);

  final String displayName;
}
