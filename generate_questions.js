const fs = require('fs');

const subjects = {
  p3: {
    name: 'IPA',
    templates: [
      { q: 'Sistem tata surya kita berada di galaksi...', o: ['Bima Sakti', 'Andromeda', 'Triangulum', 'Magellan'], a: 0 },
      { q: 'Planet terbesar dalam tata surya adalah...', o: ['Jupiter', 'Saturnus', 'Bumi', 'Mars'], a: 0 },
      { q: 'Cahaya matahari sampai ke bumi membutuhkan waktu sekitar...', o: ['8 Menit', '8 Detik', '8 Jam', '8 Hari'], a: 0 },
      { q: 'Bagian bunga yang berfungsi sebagai alat kelamin jantan adalah...', o: ['Benang Sari', 'Putik', 'Mahkota', 'Kelopak'], a: 0 },
      { q: 'Hewan yang hidup di air dan di darat disebut...', o: ['Amfibi', 'Reptil', 'Mamalia', 'Aves'], a: 0 }
    ]
  },
  p4: {
    name: 'IPS',
    templates: [
      { q: 'Ibukota negara Indonesia adalah...', o: ['Jakarta', 'Bandung', 'Surabaya', 'Medan'], a: 0 },
      { q: 'Mata uang negara Jepang adalah...', o: ['Yen', 'Won', 'Yuan', 'Ringgit'], a: 0 },
      { q: 'Garis khayal yang membagi bumi menjadi bagian utara dan selatan disebut...', o: ['Garis Khatulistiwa', 'Garis Bujur', 'Garis Lintang', 'Garis Meridian'], a: 0 },
      { q: 'Benua terbesar di dunia adalah...', o: ['Asia', 'Afrika', 'Eropa', 'Amerika'], a: 0 },
      { q: 'Kerjasama ekonomi antar negara Asia Tenggara disebut...', o: ['ASEAN', 'PBB', 'OPEC', 'NATO'], a: 0 }
    ]
  },
  p5: {
    name: 'PPKn',
    templates: [
      { q: 'Dasar negara Indonesia adalah...', o: ['Pancasila', 'UUD 1945', 'Bhinneka Tunggal Ika', 'Burung Garuda'], a: 0 },
      { q: 'Sila pertama Pancasila dilambangkan dengan...', o: ['Bintang', 'Rantai', 'Pohon Beringin', 'Kepala Banteng'], a: 0 },
      { q: 'Semboyan negara Indonesia adalah...', o: ['Bhinneka Tunggal Ika', 'Tut Wuri Handayani', 'Merdeka atau Mati', 'Pancasila'], a: 0 },
      { q: 'Lembaga yang membuat undang-undang adalah...', o: ['DPR', 'Presiden', 'MA', 'MK'], a: 0 },
      { q: 'Hak asasi manusia dijamin dalam UUD 1945 pasal...', o: ['28', '27', '29', '30'], a: 0 }
    ]
  },
  p6: {
    name: 'Bahasa Inggris',
    templates: [
      { q: 'What is the English word for "Buku"?', o: ['Book', 'Pen', 'Bag', 'Pencil'], a: 0 },
      { q: 'What is the opposite of "Big"?', o: ['Small', 'Tall', 'Long', 'Short'], a: 0 },
      { q: 'I ... a student.', o: ['am', 'is', 'are', 'was'], a: 0 },
      { q: 'She ... to the market yesterday.', o: ['went', 'go', 'goes', 'going'], a: 0 },
      { q: 'We ... dinner when the phone rang.', o: ['were eating', 'was eating', 'eat', 'eats'], a: 0 }
    ]
  },
  p7: {
    name: 'Sejarah',
    templates: [
      { q: 'Kemerdekaan Indonesia diproklamasikan pada tahun...', o: ['1945', '1944', '1946', '1908'], a: 0 },
      { q: 'Tokoh yang memproklamasikan kemerdekaan Indonesia adalah...', o: ['Soekarno-Hatta', 'Sultan Syahrir', 'Jenderal Sudirman', 'Pangeran Diponegoro'], a: 0 },
      { q: 'Kerajaan Islam pertama di Indonesia adalah...', o: ['Samudera Pasai', 'Demak', 'Mataram', 'Ternate'], a: 0 },
      { q: 'Sumpah Pemuda diikrarkan pada tahun...', o: ['1928', '1908', '1945', '1965'], a: 0 },
      { q: 'Pahlawan wanita dari Aceh adalah...', o: ['Cut Nyak Dien', 'Kartini', 'Dewi Sartika', 'Cut Meutia'], a: 0 }
    ]
  },
  p8: {
    name: 'TIK',
    templates: [
      { q: 'Perangkat keras komputer disebut juga...', o: ['Hardware', 'Software', 'Brainware', 'Malware'], a: 0 },
      { q: 'Otak dari sebuah komputer adalah...', o: ['CPU', 'RAM', 'Harddisk', 'VGA'], a: 0 },
      { q: 'Sistem operasi buatan Microsoft adalah...', o: ['Windows', 'Linux', 'macOS', 'Android'], a: 0 },
      { q: 'Jaringan komputer global disebut...', o: ['Internet', 'Intranet', 'LAN', 'WAN'], a: 0 },
      { q: 'Kepanjangan dari WWW adalah...', o: ['World Wide Web', 'World Web Wide', 'Wide World Web', 'Web World Wide'], a: 0 }
    ]
  },
  p9: {
    name: 'Agama Islam',
    templates: [
      { q: 'Nabi terakhir dalam Islam adalah...', o: ['Nabi Muhammad SAW', 'Nabi Isa AS', 'Nabi Ibrahim AS', 'Nabi Musa AS'], a: 0 },
      { q: 'Kitab suci umat Islam adalah...', o: ['Al-Quran', 'Taurat', 'Zabur', 'Injil'], a: 0 },
      { q: 'Rukun Islam ada...', o: ['5', '6', '4', '7'], a: 0 },
      { q: 'Shalat wajib sehari semalam berjumlah... rakaat.', o: ['17', '15', '20', '12'], a: 0 },
      { q: 'Puasa wajib dilaksanakan pada bulan...', o: ['Ramadhan', 'Syawal', 'Rajab', 'Sya\'ban'], a: 0 }
    ]
  }
};

let data = JSON.parse(fs.readFileSync('assets/data/questions.json'));

data.levels = data.levels.filter(l => ['p1', 'p2'].includes(l.partId)); // Keep only p1 and p2

Object.keys(subjects).forEach(pId => {
  const subject = subjects[pId];
  for (let l = 1; l <= 100; l++) {
    const levelId = pId + '_l' + l;
    let questions = [];
    for (let q = 1; q <= 10; q++) {
      const template = subject.templates[(l + q) % subject.templates.length];
      
      let options = [...template.o];
      // Randomize options slightly
      for (let i = options.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [options[i], options[j]] = [options[j], options[i]];
      }
      const answerIndex = options.indexOf(template.o[0]);

      questions.push({
        id: levelId + '_q' + q,
        text: "(Level " + l + ") " + template.q,
        options: options,
        correctAnswerIndex: answerIndex,
        explanation: 'Penjelasan ' + subject.name + ' Level ' + l + ' Soal ' + q
      });
    }
    data.levels.push({
      id: levelId,
      partId: pId,
      order: l,
      questions: questions
    });
  }
});

fs.writeFileSync('assets/data/questions.json', JSON.stringify(data, null, 2));
console.log('Successfully generated themed questions for all parts');
