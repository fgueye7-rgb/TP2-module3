<?xml version="1.0" encoding="UTF-8"?>
<!-- ISEP26-XXX — Ton Nom Prénom -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:param name="seuil" select="10"/>
  <xsl:key name="par-classe" match="etudiant" use="@classe"/>
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>promotion <xsl:value-of select="/promotion/@filiere"/> - <xsl:value-of select="/promotion/@annee"/></title>
        <link rel="stylesheet" href="style.css"/>
      </head>
      <body>
        <header>
          <h1>promotion <xsl:value-of select="/promotion/@filiere"/></h1>
          <p>Année <xsl:value-of select="/promotion/@annee"/> - Seuil : <xsl:value-of select="$seuil"/></p>
        </header>
        <main>
          <div class="stats">
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//etudiant)"/></span><span class="legende">Étudiants</span></div>
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//etudiant[sum(notes/note) div count(notes/note) &gt;= $seuil])"/></span><span class="legende">Admis</span></div>
            <div class="carte"><span class="valeur"><xsl:value-of select="format-number(sum(//note[@matiere='XML']) div count(//note[@matiere='XML']), '0.00')"/></span><span class="legende">Moyenne XML</span></div>
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//etudiant[not(email)])"/></span><span class="legende">Emails manquants</span></div>
          </div>
          <xsl:for-each select="//etudiant[generate-id() = generate-id(key('par-classe', @classe)[1])]">
            <xsl:sort select="@classe"/>
            <xsl:variable name="classe" select="@classe"/>
            <h2>Classe <xsl:value-of select="$classe"/> (<xsl:value-of select="count(key('par-classe', $classe))"/> étudiants)</h2>
            <table>
              <thead><tr><th>Rang</th><th>Matricule</th><th>Nom</th><th>Prénom</th><th>Classe</th><th>Email</th><th>Moyenne</th><th>Résultat</th></tr></thead>
              <tbody>
                <xsl:for-each select="key('par-classe', $classe)">
                  <xsl:sort select="sum(notes/note) div count(notes/note)" data-type="number" order="descending"/>
                  <xsl:variable name="moy" select="sum(notes/note) div count(notes/note)"/>
                  <tr>
                    <xsl:if test="position() = 1"><xsl:attribute name="class">major</xsl:attribute></xsl:if>
                    <td class="rang"><xsl:value-of select="position()"/></td>
                    <td><xsl:value-of select="@matricule"/></td>
                    <td><xsl:value-of select="nom"/></td>
                    <td><xsl:value-of select="prenom"/></td>
                    <td><xsl:value-of select="@classe"/></td>
                    <td><xsl:choose><xsl:when test="email"><xsl:value-of select="email"/></xsl:when><xsl:otherwise><span class="absent">non renseigné</span></xsl:otherwise></xsl:choose></td>
                    <td class="moyenne"><xsl:value-of select="format-number($moy, '0.00')"/></td>
                    <td><xsl:choose><xsl:when test="$moy &gt;= $seuil"><span class="badge reussite">Admis</span></xsl:when><xsl:otherwise><span class="badge echec">À revoir</span></xsl:otherwise></xsl:choose></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:for-each>
        </main>
        <footer>ISEP Diamniadio - Données fictives</footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>