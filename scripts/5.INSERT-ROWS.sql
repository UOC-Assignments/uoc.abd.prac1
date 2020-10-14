INSERT INTO staff 
VALUES ('11111111C',
        fullname('Elon','Reeve','Musk')
);

INSERT INTO staff 
VALUES ('2222222C',
        fullname('MacKenzie','Sheri','Tuttle')
        );

INSERT INTO students 
VALUES ('11111111A',
        111111,
        fullname('John','Winston','Lenon'),
        currentStudiesList('PHILOSOPHY','CONTEMPORARY ARTS')
);

INSERT INTO students 
VALUES ('2222222A',
        222222,
        fullname('Bob','Nesta','Marley'),
        currentStudiesList('BOTANICS','BIOENGINEERING','BIOLOGY')
);

INSERT INTO lresearches
VALUES ('ASTROPHYSICS',
        'Study of physics from a cosmological perspective',
        '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('RADIOACTIVITY',
        'Study of nuclear radiation and its properties',
        '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('COMPUTER ARCHITECTURES',
        'Computer hardware design and performance analysis',
        '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('QUANTUM PHYSICS',
        'Study of the physical properties of nature at the scale of atoms and subatomic particles',
        '1-January-2020',
		'1-January-2030'
);

INSERT INTO lresearches
VALUES ('ENGINEERING',
        ' use of scientific principles to design and build machines',
        '1-January-2020',
		'1-January-2030'
);


INSERT INTO PDIS 
VALUES ('11111111B',
        333333,
        fullname('Mileva','Marić',''),
        'PHYSICS',
        '19-December-1875',
        (select ref(d) from lResearches d where d.name='ASTROPHYSICS') 
);

INSERT INTO PDIS 
VALUES ('2222222B',
        444444,
        fullname('Marie','Skłodowska','Curie'),
        'PHYSICS',
        '7-November-1867',
        (select ref(d) from lResearches d where name='NUCLEAR FUSSION') --THE NOT NULL CLAUSE ENFORCES THE REFERENTIAL INTEGRITY CONSTRAINT (MULTIPLICITY OF "1" IN THE UML DIAGRAM)
);

INSERT INTO PDIS 
VALUES ('2222222A',
        22222,
        fullname('Marie','Sklodowska','Curie'),
        'PHYSICS',
        '7-November-1867',
        (select ref(r) from lResearches r where name='RADIOACTIVITY') 
);

INSERT INTO universities (name) -- THIS WAY THE hasAgreement_tab table constructor is automatically called (p.32 M2)
VALUES ('Universitat Oberta de Catalunya'
);

INSERT INTO companies (CIF,bussinessName,postalCode,sector)
VALUES ('Z12345678',
        'IBM',
        08080,
        'COMPUTING'
);

INSERT INTO AgreementCols
VALUES ('1-January-2020', 
        '1-January-2021', 
        (select ref(u) from universities u where u.name='Universitat Oberta de Catalunya'), 
        (select ref(c) from companies c where c.businessName='IBM'),
        'QUANTUM COMPUTING RESEARCH COLABORATION', 
		'Y',
		(select ref(s) from PDI s where s.NIF='1111111B'),
        lresearch_va((select ref(r1) from LResearch r1 where r1.name='COMPUTER ARCHITECTURES'),
		             (select ref(r2) from LResearch r2 where r2.name='QUANTUM PHYSICS'),
		             (select ref(r3) from LResearch r3 where r3.name='ENGINEERING'),
		)
);

