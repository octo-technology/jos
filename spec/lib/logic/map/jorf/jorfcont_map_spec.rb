require 'rails_helper'
require './lib/logic/map/jorf/jorfcont_map'

def fake_jorfcont_file
  <<-FOO
<JO>
  <META>
    <META_COMMUN>
      <ID>JORFCONT000000000001</ID>
      <ANCIEN_ID/>
      <ORIGINE>JORF</ORIGINE>
      <URL>conteneur/JORF/CONT/00/00/00/00/00/JORFCONT000000000001.xml</URL>
      <NATURE>JO</NATURE>
    </META_COMMUN>
    <META_SPEC>
      <META_CONTENEUR>
        <TITRE>JOUE n°113 du 7 mai 1993</TITRE>
        <NUM>113</NUM>
        <DATE_PUBLI>1993-05-07</DATE_PUBLI>
      </META_CONTENEUR>
    </META_SPEC>
  </META>
  <STRUCTURE_TXT>
    <LIEN_TXT idtxt="JORFTEXT000000339622" titretxt="Directive Européenne n°93-1 du 1 janvier 1993 DE LA COMMISSION MODIFIANT LA DIRECTIVE 77535 CEE CONCERNANT LE RAPPROCHEMENT DES LEGISLATIONS DES ETATS MEMBRES RELATIVES AUX METHODES D'ECHANTILLONNAGE ET D'ANALYSE DES ENGRAIS (METHODE D'ANALYSE POUR LES OLIGO-ELEMENTS)"/>
  </STRUCTURE_TXT>
</JO>
  FOO
end

describe 'mapping of jorfcont' do

  context "when we have one jorfcont" do

    before do
      @xml = fake_jorfcont_file
      @jorfcont_map = JorfcontMap.parse(@xml, :single => true)
      @jorfcont = @jorfcont_map.to_jorfcont
    end

    it 'maps correctly the jorfcont' do
      expect(@jorfcont.id_jorfcont_origin).to  eq("JORFCONT000000000001")
      expect(@jorfcont.nature).to   eq("JO")
      expect(@jorfcont.title).to   eq("JOUE n°113 du 7 mai 1993")
      expect(@jorfcont.number).to   eq(113)
      expect(@jorfcont.publication_date).to   eq("1993-05-07")
    end

    it 'maps correctly the cont jorf link' do
      expect(@jorfcont_map.link_cont_text_maps.length).to  eq(1)
      expect(@jorfcont_map.link_cont_text_maps[0].id_jorftext_origin).to  eq("JORFTEXT000000339622")
    end

    describe "to_jorfcont_jorftext_link_hash" do

      before do
        @hashes = @jorfcont_map.to_jorfcont_jorftext_link_hashes
      end

      it 'hash correctly the link' do
        expect(@hashes.length).to   eq(1)
        expect(@hashes[0][:id_jorfcont_origin]).to   eq("JORFCONT000000000001")
        expect(@hashes[0][:id_jorftext_origin]).to   eq("JORFTEXT000000339622")
      end
    end

  end

end

