-- Region: Dynamic Content  |  Source: PL/SQL Function Body returning CLOB
declare
  l_html   clob;
  l_mhs    number;  l_dsn number;  l_mk number;  l_kls number;
  l_krs    number;  l_prodi number; l_avg number; l_max number;
  l_ta     varchar2(100);
  l_idx    pls_integer := 0;

  function icon(p_k varchar2) return varchar2 is
  begin
    return case p_k
      when 'users' then q'~<svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9.5" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8"/></svg>~'
      when 'teacher' then q'~<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a6 6 0 0 1 6-6h4a6 6 0 0 1 6 6v1"/></svg>~'
      when 'book' then q'~<svg viewBox="0 0 24 24"><path d="M2 4h6a4 4 0 0 1 4 4v13a3 3 0 0 0-3-3H2z"/><path d="M22 4h-6a4 4 0 0 0-4 4v13a3 3 0 0 1 3-3h7z"/></svg>~'
      when 'clock' then q'~<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>~'
      when 'file' then q'~<svg viewBox="0 0 24 24"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5M9 13h6M9 17h6"/></svg>~'
      when 'trophy' then q'~<svg viewBox="0 0 24 24"><path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0z"/><path d="M17 5h3v2a3 3 0 0 1-3 3M7 5H4v2a3 3 0 0 0 3 3"/></svg>~'
      when 'chart' then q'~<svg viewBox="0 0 24 24"><path d="M4 21V10M10 21V4M16 21v-8M22 21H2"/></svg>~'
      else '' end;
  end;

  function url_of(p_name varchar2) return varchar2 is
    l_id number;
  begin
    select min(page_id) into l_id
      from apex_application_pages
     where application_id = :APP_ID and page_name = p_name;
    if l_id is null then return '#'; end if;
    return apex_page.get_url(p_page => l_id);
  exception when others then return '#';
  end;

  procedure add(p_t varchar2) is
  begin
    l_html := l_html || p_t;
  end;

  procedure add_stat(p_label varchar2, p_val number, p_icon varchar2) is
  begin
    l_idx := l_idx + 1;
    add(replace(replace(replace(replace(q'~<div class="sk-card sk-stat" style="--i:#IDX#"><div class="sk-card-in"><div class="sk-ico">#ICON#</div><div class="sk-num" data-count="#VALUE#">#VALUE#</div><div class="sk-lbl">#LABEL#</div></div></div>~',
      '#IDX#', l_idx), '#ICON#', icon(p_icon)), '#VALUE#', to_char(p_val)),
      '#LABEL#', apex_escape.html(p_label)));
  end;

  procedure add_tile(p_name varchar2, p_desc varchar2, p_icon varchar2) is
  begin
    l_idx := l_idx + 1;
    add(replace(replace(replace(replace(replace(q'~<a class="sk-tile" href="#URL#" style="--i:#IDX#"><div class="sk-ico">#ICON#</div><div class="sk-tile-t">#NAME#</div><div class="sk-tile-d">#DESC#</div><span class="sk-arrow">&rarr;</span></a>~',
      '#IDX#', l_idx), '#URL#', url_of(p_name)), '#ICON#', icon(p_icon)),
      '#NAME#', apex_escape.html(p_name)), '#DESC#', apex_escape.html(p_desc)));
  end;
begin
  select count(*) into l_mhs   from mahasiswa;
  select count(*) into l_dsn   from dosen;
  select count(*) into l_mk    from mata_kuliah;
  select count(*) into l_kls   from kelas_perkuliahan;
  select count(*) into l_krs   from krs;
  select count(*) into l_prodi from program_studi;
  select nvl(round(avg(nilai_angka),1),0) into l_avg from nilai;
  select nvl(max(tahun_akademik||' '||semester), '-') into l_ta
    from tahun_akademik where upper(status) = 'AKTIF';

  add(replace(replace(replace(q'~<div class="sk-home"><div class="sk-orb o1"></div><div class="sk-orb o2"></div><div class="sk-orb o3"></div><div class="sk-grid-bg"></div>
<section class="sk-hero"><div class="sk-hero-text"><div class="sk-eyebrow"><span class="sk-dot"></span>Portal Akademik &bull; #TA#</div>
<h1 class="sk-title">Sistem Informasi <span>Akademik</span></h1>
<p class="sk-sub">Kelola data mahasiswa, dosen, perkuliahan, KRS, dan nilai dalam satu platform yang elegan dan terintegrasi.</p>
<div class="sk-by">Dibuat oleh <b>Rizky Maulana</b></div>
<div class="sk-cta"><a class="sk-btn sk-btn-gold" href="#URL1#">Lihat Jadwal Kelas</a><a class="sk-btn sk-btn-ghost" href="#URL2#">Data Mahasiswa</a></div></div>
<div class="sk-scene"><div class="sk-ring r1"></div><div class="sk-ring r2"></div><div class="sk-ring r3"></div>
<div class="sk-cube"><i class="f1"></i><i class="f2"></i><i class="f3"></i><i class="f4"></i><i class="f5"></i><i class="f6"></i></div><div class="sk-spark s1"></div><div class="sk-spark s2"></div><div class="sk-spark s3"></div></div></section>
<section class="sk-stats">~',
      '#TA#', apex_escape.html(l_ta)), '#URL1#', url_of('Jadwal Kelas')), '#URL2#', url_of('Mahasiswa')));

  add_stat('Total Mahasiswa', l_mhs, 'users');
  add_stat('Total Dosen',     l_dsn, 'teacher');
  add_stat('Mata Kuliah',     l_mk,  'book');
  add_stat('Kelas Aktif',     l_kls, 'clock');

  add(q'~</section>
<section class="sk-two"><div class="sk-panel"><h2 class="sk-h2">Mahasiswa per Program Studi</h2><div class="sk-bars">~');

  select greatest(nvl(max(jumlah_mahasiswa),1),1) into l_max from vw_jumlah_mhs_prodi;
  for r in (select nama_prodi, jumlah_mahasiswa from vw_jumlah_mhs_prodi
             order by jumlah_mahasiswa desc, nama_prodi) loop
    add(replace(replace(replace(q'~<div class="sk-bar-row"><span class="sk-bar-name">#NAME#</span><div class="sk-bar-track"><div class="sk-bar-fill" style="--w:#PCT#%"></div></div><span class="sk-bar-val">#COUNT#</span></div>~',
      '#NAME#', apex_escape.html(r.nama_prodi)),
      '#PCT#', to_char(round(r.jumlah_mahasiswa / l_max * 100))),
      '#COUNT#', to_char(r.jumlah_mahasiswa)));
  end loop;

  add(replace(replace(replace(replace(q'~</div></div>
<div class="sk-panel"><h2 class="sk-h2">Ringkasan Periode</h2>
<div class="sk-info"><span>Periode Aktif</span><b>#TA#</b></div>
<div class="sk-info"><span>Total KRS</span><b>#KRS#</b></div>
<div class="sk-info"><span>Rata-rata Nilai</span><b>#AVG#</b></div>
<div class="sk-info"><span>Total Program Studi</span><b>#PRODI#</b></div></div></section>
<section class="sk-quick"><h2 class="sk-h2 sk-h2-wide">Akses Cepat</h2><div class="sk-tiles">~',
      '#TA#', apex_escape.html(l_ta)), '#KRS#', to_char(l_krs)),
      '#AVG#', to_char(l_avg, 'FM990.0')), '#PRODI#', to_char(l_prodi)));

  l_idx := 0;
  add_tile('Jadwal Kelas',    'Lihat jadwal kuliah',  'clock');
  add_tile('KRS Mahasiswa',   'Kartu rencana studi',  'file');
  add_tile('Nilai Mahasiswa', 'Rekap nilai',          'trophy');
  add_tile('IPS Mahasiswa',   'Indeks prestasi',      'chart');

  add(q'~</div></section><div class="sk-foot">Sistem Informasi Akademik &bull; Release 1.0</div></div>~');
  return l_html;
end;
